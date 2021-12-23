//
//  ZodiacSign+Sort.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/14/21.
//

import Foundation

extension ZodiacSign: Comparable {
    
    static func < (lhs: ZodiacSign, rhs: ZodiacSign) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
    
    var sortOrder: Int {
        switch self {
        case .ari: return 1
        case .tau: return 2
        case .gem: return 3
        case .cnc: return 4
        case .leo: return 5
        case .vir: return 6
        case .lib: return 7
        case .sco: return 8
        case .sgr: return 9
        case .cap: return 10
        case .aqr: return 11
        case .pis: return 12
        case .aql: return 0
        }
    }
}
