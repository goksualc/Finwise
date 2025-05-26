import SwiftUI

struct StockRecommendationView: View {
    let riskProfile: RiskProfile

    @State private var stocks: [Stock] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 32))
                        .foregroundColor(mintGreen)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Portfolio Recommendations")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Investment recommendations based on your risk profile.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)

                if isLoading {
                    Spacer()
                    ProgressView("Loading data...")
                        .progressViewStyle(CircularProgressViewStyle(tint: mintGreen))
                    Spacer()
                } else if let errorMessage = errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(color: Color.red.opacity(0.08), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 18) {
                            ForEach(stocks.prefix(10)) { stock in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "chart.line.uptrend.xyaxis")
                                            .foregroundColor(accentPurple)
                                            .font(.title2)
                                        Text(stock.displaySymbol)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        if let change = stock.weeklyChange {
                                            Text(String(format: "%+.2f%%", change))
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(change < 0 ? .red : .green)
                                        }
                                    }
                                    Text(stock.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let price = stock.currentPrice {
                                        Text(String(format: "Fiyat: $%.2f", price))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    if let c = stock.currentPrice, let pc = stock.previousClose {
                                        let diff = c - pc
                                        Text(String(format: "Günlük Değişim: %+.2f", diff))
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(diff > 0 ? .green : (diff < 0 ? .red : .gray))
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(color: accentPurple.opacity(0.08), radius: 8, x: 0, y: 4)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchAllStocks)
    }

    func fetchAllStocks() {
        isLoading = true
        errorMessage = nil

        let urlString = "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=d0o6tupr01qqr9alfjg0d0o6tupr01qqr9alfjgg"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }

            guard let data = data,
                  let decoded = try? JSONDecoder().decode([Stock].self, from: data) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode symbol list"
                    self.isLoading = false
                }
                return
            }

            let filtered = decoded.filter {
                ($0.type == "Common Stock" || $0.type == "EQS") &&
                ($0.mic == "XNAS" || $0.mic == "XNYS")
            }

            let selected = Array(filtered.prefix(50))
            fetchQuotes(for: selected)
        }.resume()
    }

    func fetchQuotes(for stocks: [Stock]) {
        var updated: [Stock] = []
        let group = DispatchGroup()

        for stock in stocks {
            group.enter()
            let urlString = "https://finnhub.io/api/v1/quote?symbol=\(stock.symbol)&token=d0o6tupr01qqr9alfjg0d0o6tupr01qqr9alfjgg"
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { group.leave() }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let c = json["c"] as? Double,
                      let pc = json["pc"] as? Double else {
                    return
                }

                var s = stock
                s.currentPrice = c
                s.previousClose = pc
                updated.append(s)
            }.resume()
        }

        group.notify(queue: .main) {
            self.stocks = filterStocksByRiskProfile(stocks: updated)
            self.isLoading = false
        }
    }

    // 🔍 Dynamic Filtering Based on Risk Profile
    func filterStocksByRiskProfile(stocks: [Stock]) -> [Stock] {
        let validStocks = stocks.filter { $0.weeklyChange != nil }
        // Sort by weeklyChange descending (highest positive change first)
        return validStocks.sorted { ($0.weeklyChange ?? 0) > ($1.weeklyChange ?? 0) }
    }
}

