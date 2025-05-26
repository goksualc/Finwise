//
//  InvestmentCategory.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct InvestmentCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let assets: [String]
}
