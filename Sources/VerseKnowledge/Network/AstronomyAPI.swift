//
//  AstronomyAPI.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/10/21.
//

import Foundation
import CoreLocation

struct AstronomyAPI {
    enum AstronomyError: Error {
        case badRequest
        case badResponse
        case badStatus
    }
    
    private struct DataFetcher {
        static func fetchData(_ request: URLRequest) async throws -> Data {
            let ret = try await URLSession.shared.data(for: request)
            guard (ret.1 as? HTTPURLResponse)?.statusCode == 200 else { throw AstronomyError.badStatus }
            return ret.0
        }
    }
    
    public enum Request {
        case getAvailableBodies
        case getAllBodyPositions
        case getBodyPosition(_ body: CelestialBody)
        
        var urlComponents: URLComponents {
            switch self {
            case .getAvailableBodies:
                return URLComponents(
                    url: AstronomyAPI.baseURL.appendingPathComponent("bodies"),
                    resolvingAgainstBaseURL: false)!
            case .getAllBodyPositions:
                return URLComponents(
                    url: AstronomyAPI.baseURL.appendingPathComponent("bodies/positions"),
                    resolvingAgainstBaseURL: false)!
            case .getBodyPosition(let body):
                return URLComponents(
                    url: AstronomyAPI.baseURL.appendingPathComponent("bodies/positions/\(body.rawValue)"),
                    resolvingAgainstBaseURL: false)!
            }
        }
    }
    
    public struct Observer {
        let location: CLLocation
        let date: Date
        
        var fromDate: Date { date }
        var toDate: Date { date }
        
        init(location: CLLocation, targetDate: Date = Date()) {
            self.location = location
            self.date = targetDate
        }
    }
    
    static fileprivate let apiKey: String = { "7aea438e-0154-438c-b51f-dbc6d62a9e3c:ae53cf5169aa4ecd417ea4113b7dcc9b26c828225152974adfc50e6d6d7f32152b759d3ca4a6d551e3cb9296a9a524d5782109cf58e76e18837e2c605082d298820f8a27c30ec7a6fa0863935e2b2017cda5e5aa8afe12e24523c06ea60396c73a8d3a4bf7c217dc82475819c907ca85"
            .toBase64()
    }()
    
    static private var baseURL: URL {
        URL(string: "https://api.astronomyapi.com/api/v2/")!
    }
    
    static public func availableBodies(observer: Observer) async throws -> [CelestialBody] {
        let data = try await DataFetcher.fetchData(
            urlRequest(for: .getAvailableBodies, observer: observer)
        )
        return try JSONDecoder().decode(BodiesResponse.self, from: data).bodies
    }
    
    static public func fetchSky(observer: Observer) async throws -> AstronomyAPI.PositionResponse? {
        let data = try await DataFetcher.fetchData(
            urlRequest(for: .getAllBodyPositions, observer: observer)
        )
        return try JSONDecoder().decode(PositionResponse.self, from: data)
    }
    
    static public func locateBody(_ body: CelestialBody, observer: Observer) async throws -> AstronomyAPI.PositionResponse? {
        let data = try await DataFetcher.fetchData(
            urlRequest(for: .getBodyPosition(body), observer: observer )
        )
        return try JSONDecoder().decode(PositionResponse.self, from: data)
    }
    
    static private func urlRequest(for apiRequest: Request, observer: Observer) -> URLRequest {
        var components = apiRequest
            .urlComponents
        components.queryItems = observer
            .queries
        return URLRequest(
            url: components.url!,
            cachePolicy: .returnCacheDataElseLoad
        )
        .addingAstronomyAuthHeader
    }
    
}

extension AstronomyAPI {
    struct BodiesResponse: Decodable {
        struct BodySet: Decodable {
            var bodies: [CelestialBody]
        }
        private var data: BodySet
        
        var bodies: [CelestialBody] {
            data.bodies
        }
    }
    
    struct PositionResponse: Decodable {
        fileprivate struct Data: Decodable {
            struct DateRange: Decodable {
                let to: String
                let from: String
            }
            struct Table: Decodable {
                struct Row: Decodable {
                    struct Cell: Decodable {
                        struct Distances: Decodable {
                            struct Distance: Decodable {
                                let au: String
                                let km: String
                            }
                            
                            let fromEarth: Distance
                        }
                        struct Position: Decodable {
                            struct Horizontal: Decodable {
                                struct Azimuth: Decodable {
                                    let degrees: String
                                    let string: String
                                }
                                struct Altitude: Decodable {
                                    let degrees: String
                                    let string: String
                                }
                                
                                let azimuth: Azimuth
                                let altitude: Altitude
                            }
                            struct Equatorial: Decodable {
                                struct RightAscension: Decodable {
                                    let hours: String
                                    let string: String
                                }
                                
                                let rightAscension: RightAscension
                            }
                            
                            let horizonal: Horizontal
                            let equatorial: Equatorial
                        }
                        struct More: Decodable {
                            let elongation: String?
                            let magnitude: String?
                            let phase: LunarPhase?
                        }
                        
                        let date: String
                        let id: String
                        let extraInfo: More
                        let name: String
                        let distance: Distances
                        let position: Position
                    }
                    struct Entry: Decodable {
                        let id: String
                        let name: String
                    }
                    let cells: [Cell]
                    let entry: Entry
                }
                let rows: [Row]
            }
            let dates: DateRange
            let table: Table
        }
        
        private let data: Data
    }
}

extension AstronomyAPI.PositionResponse {
    var coordinates: [CelestialBody: CelestialCoordinates] {
        var angles: [CelestialBody: CelestialCoordinates] = [:]
        // Step through bodies
        for row in data.table.rows {
            guard let body = CelestialBody(rawValue: row.entry.id), let cell = row.cells.first else {
                break
            }
            
            let distance = Measurement(value: Double(cell.distance.fromEarth.au)!, unit: UnitLength.astronomicalUnits)
            
            let ra = Measurement(value: Double(cell.position.equatorial.rightAscension.hours)!, unit: UnitAngle.equatorialHours)
            
            let azimuth = Measurement(value: Double(cell.position.horizonal.azimuth.degrees)!, unit: UnitAngle.degrees)
            let altitude = Measurement(value: Double(cell.position.horizonal.altitude.degrees)!, unit: UnitAngle.degrees)
            
            angles[body] = .init(
                zodiac: ra,
                azimuth: azimuth,
                altitude: altitude,
                distance: distance)
        }
        return angles
    }
}

fileprivate extension URLRequest {
    var addingAstronomyAuthHeader: URLRequest {
        var req = self
        req.addValue("Basic \(AstronomyAPI.apiKey)", forHTTPHeaderField: "Authorization")
        return req
    }
}

fileprivate extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df
    }()
}

fileprivate extension AstronomyAPI.Observer {
    var queries: [URLQueryItem] {
        [
           .init(name: "longitude", value: "\(location.coordinate.longitude)"),
           .init(name: "latitude", value: "\(location.coordinate.latitude)"),
           .init(name: "elevation", value: "\(Int(location.altitude))"),
           .init(name: "from_date", value: "\(fromDate.formatted(.iso8601.year().month().day().dateSeparator(.dash)))"),
           .init(name: "to_date", value: "\(toDate.formatted(.iso8601.year().month().day().dateSeparator(.dash)))"),
           .init(name: "time", value: "\(DateFormatter.timeFormatter.string(from: fromDate))")
       ]
    }
}


