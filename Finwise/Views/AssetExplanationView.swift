
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
