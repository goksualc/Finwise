import SwiftUI
import WebKit

struct FundTypeIdentifiable: Identifiable, Equatable {
    let id: String
    var fundType: String { id }
}

struct RiskResultView: View {
    let totalScore: Int
    @Environment(\.dismiss) private var dismiss
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
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
        let base = "https://finance.yahoo.com/research-hub/screener/etf/?start=0&count=25"
        let query = fundType.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(base)&query=\(query)")!
    }
    var body: some View {
        NavigationStack {
            WebView(url: yahooURL)
                .navigationTitle("\(fundType) ETF's")
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
