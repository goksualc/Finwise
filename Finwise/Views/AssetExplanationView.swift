//
//  AssetExplanationView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct AssetExplanationView: View {
    var body: some View {
        List {
            Section(header: Text("Varlık Türleri")) {
                Text("Altın: Değerli metal, güvenli liman yatırımı.")
                Text("Hisse: Şirket ortaklık payı.")
                Text("Eurobond: Yabancı para cinsinden devlet/şirket tahvili.")
                // Add more as needed
            }
        }
        .navigationTitle("Varlık Açıklamaları")
    }
}
