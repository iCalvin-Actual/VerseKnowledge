//
//  AstrologicalReading.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/14/21.
//

import Foundation

struct AstrologicalReading {
    let pentacle: Pentacle
    let chart: SkyData?
    
    var targetDate: Date { pentacle.date }
    
    var sol: BodyCoordinates        { (body: .sun, coordinates: chart!.data[.sun]!) }
    var mercury: BodyCoordinates    { (body: .mercury, coordinates: chart!.data[.mercury]!) }
    var venus: BodyCoordinates      { (body: .venus, coordinates: chart!.data[.venus]!) }
    var moon: BodyCoordinates       { (body: .moon, coordinates: chart!.data[.moon]!) }
    var mars: BodyCoordinates       { (body: .mars, coordinates: chart!.data[.mars]!) }
    var jupiter: BodyCoordinates    { (body: .jupiter, coordinates: chart!.data[.jupiter]!) }
    var saturn: BodyCoordinates     { (body: .saturn, coordinates: chart!.data[.saturn]!) }
    var uranus: BodyCoordinates     { (body: .uranus, coordinates: chart!.data[.uranus]!) }
    var neptune: BodyCoordinates    { (body: .neptune, coordinates: chart!.data[.neptune]!) }
    var pluto: BodyCoordinates      { (body: .pluto, coordinates: chart!.data[.pluto]!) }
    
    func reading(for body: CelestialBody) -> BodyCoordinates? {
        guard let coordinates = chart?.data[body] else {
            return nil
        }
        return (body: body, coordinates: coordinates)
    }
}
