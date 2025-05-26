//
//  FundTypeIdentifiable.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/27/25.
//

import Foundation

struct FundTypeIdentifiable: Identifiable, Equatable {
    let id: String
    var fundType: String { id }
}
