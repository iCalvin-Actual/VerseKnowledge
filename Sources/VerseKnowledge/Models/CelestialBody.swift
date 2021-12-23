//
//  SolarBody.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/10/21.
//

import Foundation

enum CelestialBody: String, Decodable, Comparable, SymbolicRepresentable {
    static func < (lhs: CelestialBody, rhs: CelestialBody) -> Bool {
        rhs.sortOrder < lhs.sortOrder
    }
    
    static var prefix: String {
        "celestial-symbol-"
    }
    
    case sun
    case moon
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    case pluto
    
    var id: String {
        rawValue
    }
    
    var sortOrder: Int {
        switch self {
        case .sun:      return 0
        case .mercury:  return 1
        case .venus:    return 2
        case .earth:    return 3
        case .moon:     return 4
        case .mars:     return 5
        case .jupiter:  return 6
        case .saturn:   return 7
        case .uranus:   return 8
        case .neptune:  return 9
        case .pluto:    return 10
        }
    }
    
    var displayValue: String {
        switch self {
        case .sun:      return "Sol"
        case .mercury:  return "Mercury"
        case .venus:    return "Venus"
        case .earth:    return "Earth"
        case .moon:     return "Luna"
        case .mars:     return "Mars"
        case .jupiter:  return "Jupiter"
        case .saturn:   return "Saturn"
        case .uranus:   return "Uranus"
        case .neptune:  return "Neptune"
        case .pluto:    return "Pluto"
        }
    }
}


