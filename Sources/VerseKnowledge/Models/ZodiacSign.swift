//
//  ZodiacSign.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/14/21.
//

import Foundation

enum ZodiacSign: String, Codable {
    
    static let individualSize: Double = 30.0
    
    static func indexed(_ offset: Int) -> ZodiacSign {
        switch offset % 12 {
        case 0: return .ari
        case 1: return .tau
        case 2: return .gem
        case 3: return .cnc
        case 4: return .leo
        case 5: return .vir
        case 6: return .lib
        case 7: return .sco
        case 8: return .sgr
        case 9: return .cap
        case 10: return .aqr
        case 11: return .pis
        default: return .aql
        }
    }
    
    case ari
    case tau
    case gem
    case cnc
    case leo
    case vir
    case lib
    case sco
    case sgr
    case cap
    case aqr
    case pis
    case aql
    
    var id: String { rawValue }
    
    var displayValue: String {
        switch self {
        case .ari: return NSLocalizedString("Aries", comment: "")
        case .tau: return NSLocalizedString("Taurus", comment: "")
        case .gem: return NSLocalizedString("Gemeni", comment: "")
        case .cnc: return NSLocalizedString("Cancer", comment: "")
        case .leo: return NSLocalizedString("Leo", comment: "")
        case .vir: return NSLocalizedString("Virgo", comment: "")
        case .lib: return NSLocalizedString("Libra", comment: "")
        case .sco: return NSLocalizedString("Scorpio", comment: "")
        case .sgr: return NSLocalizedString("Sagittarius", comment: "")
        case .cap: return NSLocalizedString("Capricorn", comment: "")
        case .aql: return NSLocalizedString("Terra Firma", comment: "")
        case .aqr: return NSLocalizedString("Aquarius", comment: "")
        case .pis: return NSLocalizedString("Pisces", comment: "")
        }
    }
}
