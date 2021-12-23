//
//  UnitAngle.swift
//  
//
//  Created by Calvin Chestnut on 12/23/21.
//

import Foundation

extension UnitAngle {
    static var equatorialHours: UnitAngle {
        UnitAngle(symbol: "h", converter: UnitConverterLinear(coefficient: 15))
    }
}
