//
//  Wind.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/10/21.
//

import Foundation

// Carries messages and whispers knowdge across the Earth
actor Wind {
    func celestialBodies(observer: AstronomyAPI.Observer) async -> [CelestialBody]? {
        do {
            return try await AstronomyAPI.availableBodies(observer: observer)
        } catch let e {
            print(e)
            return nil
        }
    }
    
    func positions(observer: AstronomyAPI.Observer) async -> AstronomyAPI.PositionResponse? {
        do {
            return try await AstronomyAPI.fetchSky(observer: observer)
        } catch let e {
            print(e)
            return nil
        }
    }
    
    func positions(for body: CelestialBody, observer: AstronomyAPI.Observer) async -> AstronomyAPI.PositionResponse? {
        do {
            return try await AstronomyAPI.locateBody(body, observer: observer)
        } catch let e {
            print(e)
            return nil
        }
    }
}
