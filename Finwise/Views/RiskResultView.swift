import SwiftUI
import WebKit

struct FundTypeIdentifiable: Identifiable, Equatable {
    let id: String
    var fundType: String { id }
}

struct RiskResultView: View {
    let totalScore: Int
    @State private var showStockRecommendation = false
    @State private var selectedFundType: FundTypeIdentifiable? = nil
    var riskProfile: RiskProfile {
        RiskProfile.profile(for: totalScore)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text(riskProfile.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(riskProfile.color)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text(riskProfile.summary)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Recommended Fund Types:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(riskProfile.recommendedFunds, id: \.self) { fund in
                        Button(action: {
                            selectedFundType = FundTypeIdentifiable(id: fund)
                        }) {
                            Text(fund)
                                .font(.subheadline)
                                .foregroundColor(riskProfile.color)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(riskProfile.color.opacity(0.12))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Text(riskProfile.personalMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                showStockRecommendation = true
            }) {
                Text("View Stock Recommendation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(riskProfile.color)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Risk Profile Result")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showStockRecommendation) {
            StockRecommendationView(riskProfile: riskProfile)
        }
        .sheet(item: $selectedFundType) { fundTypeIdentifiable in
            FundTypeETFListView(fundType: fundTypeIdentifiable.fundType)
        }
    }
}

// MARK: - WebView for Yahoo Finance ETF Screener
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct FundTypeETFListView: View, Identifiable {
    let fundType: String
    var id: String { fundType }
    var yahooURL: URL {
        let fundTypeKeywordMap: [String: String] = [
            "Long Term Bond ETFs 80%": "long term bond etf",
            "Commoditie Broad Basket 10%": "commodity broad basket etf",
            "Large Value 10%": "large value etf",
            
            "Long Term Bond ETFs 30%": "long term bond etf",
            "Corporate Bond 20%": "corporate bond etf",
            "Equity ETFs (Large Cap) 20%": "large cap equity etf",
            "Europe Stock 10%": "europe stock etf",
            "Commodity ETFs (Gold) 10%": "gold etf",
            "Emerging Market Bond ETFs 10%": "emerging bond etf",
            
            "Large Value 30%": "large value etf",
            "Large Growth 10%": "large growth etf",
            "China 10%": "china etf",
            "Europe 10%": "europe etf",
            "Emerging Market ETFs 10%": "emerging market etf",
            "Bond ETFs 20%": "bond etf",
            "Alternative ETFs (Gold, REIT) 10%": "reit gold etf",
            
            "Large Growth ETFs 50%": "large growth etf",
            "Europe Stock 25%": "europe stock etf",
            "Technology ETFs (AI, Disruptive) 10%": "ai technology disruptive etf",
            "Sector ETFs (Tech, Healthcare) 10%": "sector tech healthcare etf",
            "Bond ETFs 5%": "bond etf",
            
            "Technology ETFs (AI, Blockchain) 20%": "ai blockchain etf",
            "Large Growth ETFs 20%": "large growth etf",
            "Mid-cap Growth 20%": "mid cap growth etf",
            "Emerging Market ETFs 20%": "emerging market etf",
            "Crypto-related ETFs 10%": "crypto etf",
            "Sector ETFs (Biotech, Clean) 10%": "biotech clean energy etf"
        ]
        
        let keyword = fundTypeKeywordMap[fundType.trimmingCharacters(in: .whitespaces)] ?? "etf"
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "etf"
        return URL(string: "https://finance.yahoo.com/lookup/etf?s=\(encodedKeyword)")!
    }

    var body: some View {
        NavigationStack {
            WebView(url: yahooURL)
                .navigationTitle("\(fundType) ETF'leri")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#if DEBUG
struct RiskResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RiskResultView(totalScore: 10)
            RiskResultView(totalScore: 20)
            RiskResultView(totalScore: 30)
            RiskResultView(totalScore: 40)
            RiskResultView(totalScore: 55)
        }
    }
}
#endif 
