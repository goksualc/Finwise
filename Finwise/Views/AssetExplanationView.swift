//
//  AssetExplanationView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct AssetExplanationView: View {
    var body: some View {
        List {
            Section(header: Text("Asset Types")) {
                Text("Gold: Precious metal, safe haven investment.")
                Text("Stock: Company equity share.")
                Text("Eurobond: Foreign currency-denominated government/company bond.")
            }
            // Add more as needed
            }
            .navigationTitle("Asset Descriptions")
        }
    }
