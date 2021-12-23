//
//  Zodiac.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/14/21.
//

import Foundation

typealias ZodiacProgression = Measurement<UnitAngle>

extension ZodiacProgression {
    var magickalAttributes: String? {
        "With Sol at 23° Aries Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    }
    
    var sign: ZodiacSign {
        let degAeries = self.converted(to: UnitAngle.degrees).value
        return ZodiacSign.indexed(Int(floor(degAeries / ZodiacSign.individualSize)))
    }
    
    static var random: ZodiacProgression {
        ZodiacProgression(value: Double.random(in: 0.0..<24.0), unit: .equatorialHours)
    }
}
