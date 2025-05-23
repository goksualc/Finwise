import SwiftUI

struct RiskProfileSelectionView: View {
    let onSelect: (Int) -> Void
    let currentRiskProfileTitle: String?
    let profiles: [(String, Int)] = [
        ("Çok Koruyucu (0–12)", 6),
        ("Koruyucu (13–24)", 18),
        ("Dengeli (25–36)", 30),
        ("Agresif (37–48)", 42),
        ("Çok Agresif (49–60)", 55)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                if let current = currentRiskProfileTitle {
                    Text("Mevcut risk profiliniz: \(current)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                List(profiles, id: \.1) { profile in
                    Button(action: { onSelect(profile.1) }) {
                        Text(profile.0)
                            .font(.headline)
                            .padding()
                    }
                }
            }
            .navigationTitle("Risk Profilini Seç")
        }
    }
} 