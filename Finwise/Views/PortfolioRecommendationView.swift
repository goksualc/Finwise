import SwiftUI

struct Stock: Identifiable, Decodable {
    let id = UUID()
    let symbol: String
    let displaySymbol: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case displaySymbol
        case description
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
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("For a \(riskProfile.title):")
                .font(.title2)
                .padding(.bottom)
            
            if isLoading {
                ProgressView("Loading stocks...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(stocks.prefix(10)) { stock in // Show first 10 as example
                    VStack(alignment: .leading) {
                        Text(stock.displaySymbol)
                            .font(.headline)
                        Text(stock.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
        }
        .padding()
        .onAppear(perform: fetchStocks)
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func fetchStocks() {
        isLoading = true
        errorMessage = nil
        let apiKey = "d0o612hr01qn5ghnevegd0o612hr01qn5ghnevf0"
        guard let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(apiKey)") else {
            errorMessage = "Invalid API URL"
            isLoading = false
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode([Stock].self, from: data)
                    stocks = decoded
                    print("aa")
                    print(stocks.count)
                    print(stocks.first)
                } catch {
                    errorMessage = "Failed to decode stocks"
                }
            }
        }.resume()
    }
} 
