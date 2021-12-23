//
//  SymbolicRepresentation.swift
//  MyVerse
//
//  Created by Calvin Chestnut on 6/14/21.
//

import Foundation
import SwiftUI

protocol SymbolicRepresentable {
    static var prefix: String { get }
    var id: String { get }
    var displayValue: String { get }
}

extension SymbolicRepresentable {
    var symbol: Image {
        return Image(symbolAssetName, label: Text(id))
    }
    
    private var symbolAssetName: String {
        Self.prefix + id
    }
}

extension ZodiacSign: SymbolicRepresentable {
    internal static var prefix: String { "zodiac-symbol-"}
}
