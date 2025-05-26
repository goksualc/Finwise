//
//  Stock.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/27/25.
//

import Foundation

struct Stock: Identifiable, Decodable {
    let id = UUID()
    let symbol: String
    let displaySymbol: String
    let description: String
    let type: String?
    let mic: String?

    var currentPrice: Double?
    var previousClose: Double?

    var weeklyChange: Double? {
        guard let c = currentPrice, let pc = previousClose, pc != 0 else { return nil }
        return ((c - pc) / pc) * 100
    }

    enum CodingKeys: String, CodingKey {
        case symbol
        case displaySymbol
        case description
        case type
        case mic
    }
}
