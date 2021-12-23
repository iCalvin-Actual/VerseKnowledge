//
//  AstronomyAPIRequests.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/9/21.
//

import CoreLocation
import Foundation

typealias Pentacle = AstronomyAPI.Observer
typealias BodyCoordinates = (body: CelestialBody, coordinates: CelestialCoordinates)

struct SkyData {
    let data: [CelestialBody: CelestialCoordinates]
}
