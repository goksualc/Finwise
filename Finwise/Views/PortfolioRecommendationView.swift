import SwiftUI

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

struct PortfolioRecommendationView: View {
    let riskProfile: RiskProfile

    @State private var stocks: [Stock] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Portfolio Recommendation")
                .font(.largeTitle).bold().padding(.top)

            Text("Risk Profile: \(riskProfile.title)")
                .font(.headline).foregroundColor(riskProfile.color)

            if isLoading {
                ProgressView("Loading EOD data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            } else {
                List(stocks.prefix(10)) { stock in
                    VStack(alignment: .leading) {
                        Text(stock.displaySymbol).font(.headline)
                        Text(stock.description).font(.subheadline).foregroundColor(.secondary)
                        if let change = stock.weeklyChange {
                            Text(String(format: "1-Day Change: %.2f%%", change))
                                .font(.caption)
                                .foregroundColor(change < 0 ? .red : .green)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
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

        switch riskProfile.title {
        case let title where title.contains("Very Conservative"):
            return validStocks.sorted { abs($0.weeklyChange!) < abs($1.weeklyChange!) }

        case let title where title.contains("Conservative"):
            return validStocks.sorted {
                guard let c1 = $0.weeklyChange, let c2 = $1.weeklyChange else { return false }
                return c1 < c2 // prefer smaller but positive returns
            }

        case let title where title.contains("Balanced"):
            return validStocks.sorted {
                guard let c1 = $0.weeklyChange, let c2 = $1.weeklyChange else { return false }
                return abs(c1 - 5.0) < abs(c2 - 5.0) // centered around ~5% growth
            }

        case let title where title.contains("Aggressive"):
            return validStocks.sorted {
                guard let c1 = $0.weeklyChange, let c2 = $1.weeklyChange else { return false }
                return c1 > c2 // high to low performance
            }

        default:
            return validStocks
        }
    }
}

