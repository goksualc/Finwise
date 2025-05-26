//
//  UserWalletView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserWalletView: View {
    @State private var selectedTab: WalletTab = .wallet
    enum WalletTab: String, CaseIterable, Identifiable {
        case wallet = "Wallet"
        case whatIHave = "What I Have"
        var id: String { self.rawValue }
    }

    // Dummy data for demonstration; replace with real data from QuestionnaireView
    @State private var assets: [String: Double] = [:]
    @State private var recommendedFunds: [String] = []
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple

    // --- New Feature: Investment Option Selection ---
    @State private var selectedOptions: Set<String> = []
    @State private var showRecommendation = false
    @State private var recommendationText = ""
    @State private var isSaving = false
    @State private var showSaveResult = false
    @State private var saveResultMessage = ""
    let allOptions: [String] = [
        "AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "META", "NVDA", "NFLX", "BABA", "JPM", "V", "MA", "UNH", "HD", "PG", "DIS", "ADBE", "CRM", "PYPL", "INTC", "AMD", "CSCO", "ORCL", "PEP", "KO", "NKE", "T", "VZ", "PFE", "MRK", "WMT", "COST", "MCD", "SBUX", "BA", "GE", "CAT", "MMM", "IBM", "GS", "AXP", "CVX", "XOM", "BP", "TOT", "RDS.A", "BTC", "ETH", "AVAX", "SOL", "BNB", "DOGE", "ADA", "XRP", "DOT", "UNI", "LTC", "LINK", "MATIC", "SHIB", "GOLD", "SILVER", "PLATINUM", "COPPER", "OIL", "NATGAS", "SPY", "QQQ", "DIA", "IWM", "VTI", "VOO", "ARKK", "ARKG", "ARKW", "ARKF", "ARKQ", "ARKX", "XLK", "XLF", "XLE", "XLY", "XLI", "XLC", "XLV", "XLP", "XLU", "XLB", "XBI", "IBB", "VGT", "VHT", "VFH", "VNQ", "VYM", "VIG", "SCHD", "FDX", "UPS", "TGT", "LOW", "GM", "F", "TM", "HMC", "SONY", "SAP", "SHOP", "SQ", "PLTR", "SNOW", "COIN", "ROKU", "TWLO", "ZM", "DOCU", "UBER", "LYFT", "ABNB", "BKNG", "EXPE", "MAR", "HLT", "DAL", "UAL", "AAL", "LUV", "RCL", "CCL", "NCLH", "SIRI", "PINS", "TWTR", "SPOT", "MTCH", "BIDU", "JD", "NTES", "TME", "EDU", "YNDX", "RSX", "EWZ", "EWW", "EWL", "EWP", "EWG", "EWQ", "EWI", "EWD", "EWU", "EWA", "EWC", "EWH", "EWS", "EWT", "EWY", "INDA", "TUR", "GREK", "ARGT", "EIDO", "THD", "VNM", "FM", "FRDM", "KWEB", "CQQQ", "ASHR", "MCHI", "FXI", "PGJ", "CHIQ", "GXC", "CXSE", "YINN", "YANG", "RSXJ", "ERUS", "OGZPY", "LUKOY", "SBERY", "YNDX", "POLY", "PHOR", "BTC-USD", "ETH-USD", "AVAX-USD", "SOL-USD", "BNB-USD", "DOGE-USD", "ADA-USD", "XRP-USD", "DOT-USD", "UNI-USD", "LTC-USD", "LINK-USD", "MATIC-USD", "SHIB-USD"
    ]
    @State private var expandedCategories: Set<String> = []
    @State private var showWhatIHaveResult = false
    @State private var whatIHaveRecommendations: [String] = []
    @State private var isLoadingWallet = false
    @State private var walletError: String? = nil

    func saveWalletToDatabase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            saveResultMessage = "User not found."
            showSaveResult = true
            return
        }
        isSaving = true
        let db = Firestore.firestore()
        let walletData: [String: Any] = [
            "assets": assets,
            "recommendedFunds": recommendedFunds,
            "selectedOptions": Array(selectedOptions)
        ]
        db.collection("userWallets").document(userId).setData(walletData) { error in
            isSaving = false
            if let error = error {
                saveResultMessage = "Failed to save: \(error.localizedDescription)"
            } else {
                saveResultMessage = "Wallet saved successfully!"
            }
            showSaveResult = true
        }
    }

    func smartRecommendations(for selected: Set<String>) -> [String] {
        // Define categories and their recommendations
        let categories: [(name: String, assets: Set<String>, recs: [String])] = [
            ("Technology Stocks", ["AAPL", "MSFT", "TSLA", "GOOGL", "META", "NVDA", "AMD", "NFLX", "ADBE", "CRM", "PYPL", "INTC", "ORCL", "CSCO", "VGT", "ARKK", "ARKW", "ARKF", "ARKQ", "ARKX"], ["AMD", "VGT", "ARKK"]),
            ("Cryptocurrencies", ["BTC", "ETH", "ADA", "DOT", "MATIC", "LINK", "BNB", "SOL", "AVAX", "XRP", "DOGE", "SHIB", "UNI", "LTC"], ["DOT", "MATIC", "LINK"]),
            ("Safe Assets", ["GOLD", "SILVER", "PLATINUM", "DXY", "T-Bonds", "VIG", "Time Deposit", "USD/TRY", "T-Bond 10Y", "Mevduat"], ["T-Bonds", "Time Deposit", "VIG"]),
            ("ETFs & Index Funds", ["SPY", "QQQ", "DIA", "IWM", "VTI", "VOO", "ARKK", "ARKG", "ARKW", "ARKF", "ARKQ", "ARKX", "VGT", "VHT", "VFH", "VNQ", "VYM", "VIG", "SCHD"], ["VTI", "SCHD", "VIG"]),
            ("Energy & Commodities", ["XOM", "CVX", "OIL", "GOLD", "SILVER", "COPPER"], ["COPPER", "OIL", "XOM"]),
            ("Consumer Stocks", ["WMT", "KO", "MCD", "SBUX", "TGT"], ["KO", "MCD", "WMT"]),
            ("Health Stocks", ["PFE", "MRK", "UNH", "ABBV"], ["UNH", "ABBV", "MRK"]),
            ("Transportation & Travel", ["ABNB", "UBER", "FDX", "DAL", "AAL"], ["FDX", "DAL", "ABNB"]),
            ("Emerging Markets", ["KWEB", "FXI", "EWZ", "INDA", "TUR", "GREK"], ["KWEB", "FXI", "EWZ"])
        ]
        // Count matches for each category
        let counts = categories.map { (cat) -> (String, Int, [String]) in
            (cat.name, selected.intersection(cat.assets).count, cat.recs)
        }
        // Get top categories by count, filter out those with no matches
        let topCategories = counts.filter { $0.1 > 0 }.sorted { $0.1 > $1.1 }.prefix(5)
        // For each top category, return a recommendation string
        let recs: [String] = topCategories.map { cat in
            "For \(cat.0): Other users with similar portfolios also invested in \(cat.2[0]) and \(cat.2[1]). Based on that, we recommend \(cat.2[2])."
        }
        return recs
    }

    func fetchWalletFromDatabase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.walletError = "User not found."
            return
        }
        isLoadingWallet = true
        let db = Firestore.firestore()
        db.collection("userProfiles").document(userId).getDocument { document, error in
            isLoadingWallet = false
            if let error = error {
                self.walletError = error.localizedDescription
                return
            }
            guard let data = document?.data() else {
                self.walletError = "No profile data found."
                return
            }
            // Read each asset field directly
            self.assets = [
                "Gold": (data["gold"] as? Double) ?? 0,
                "Cash": (data["cash"] as? Double) ?? 0,
                "Bond": (data["bond"] as? Double) ?? 0,
                "Stocks": (data["stocks"] as? Double) ?? 0
            ]
            // Fetch recommended funds based on risk score
            if let riskScore = data["riskProfile"] as? Int ?? data["riskTotalScore"] as? Int {
                self.recommendedFunds = RiskProfile.profile(for: riskScore).recommendedFunds
            } else {
                self.recommendedFunds = []
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 32))
                        .foregroundColor(mintGreen)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Wallet")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Your assets and investments.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)
                Picker("Wallet Tab", selection: $selectedTab) {
                    ForEach(WalletTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 16)
                if selectedTab == .wallet {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Assets")
                                .font(.headline)
                                .foregroundColor(mintGreen)
                            ForEach(["Gold", "Cash", "Bond", "Stocks"], id: \.self) { key in
                                HStack {
                                    Text(key)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(String(format: "$%.2f", assets[key] ?? 0))
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 4)
                            }
                            Divider().background(mintGreen)
                            Text("Investments")
                                .font(.headline)
                                .foregroundColor(mintGreen)
                            if recommendedFunds.isEmpty {
                                Text("No recommended funds. Complete your risk profile to see recommendations.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(recommendedFunds, id: \.self) { fund in
                                    Text("• \(fund)")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: mintGreen.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                        // Fancy Submit Button for Wallet
                       
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                        .disabled(isSaving)
                    }
                } else if selectedTab == .whatIHave {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            Text("Select 3-20 Investments for Recommendations")
                                .font(.headline)
                                .foregroundColor(accentPurple)
                                .padding(.horizontal)
                            ForEach(investmentCategories) { category in
                                VStack(alignment: .leading, spacing: 0) {
                                    Button(action: {
                                        if expandedCategories.contains(category.name) {
                                            expandedCategories.remove(category.name)
                                        } else {
                                            expandedCategories.insert(category.name)
                                        }
                                    }) {
                                        HStack(spacing: 14) {
                                            ZStack {
                                                Circle()
                                                    .fill(category.color.opacity(0.18))
                                                    .frame(width: 38, height: 38)
                                                Image(systemName: category.icon)
                                                    .font(.title2)
                                                    .foregroundColor(category.color)
                                            }
                                            Text(category.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: expandedCategories.contains(category.name) ? "chevron.down" : "chevron.right")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(12)
                                        .shadow(color: category.color.opacity(0.08), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    if expandedCategories.contains(category.name) {
                                        VStack(spacing: 12) {
                                            ForEach(category.assets, id: \.self) { option in
                                                InvestmentOptionCardFancy(
                                                    label: option,
                                                    isSelected: selectedOptions.contains(option),
                                                    color: category.color
                                                ) {
                                                    if selectedOptions.contains(option) {
                                                        selectedOptions.remove(option)
                                                    } else if selectedOptions.count < 20 {
                                                        selectedOptions.insert(option)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                            Button(action: {
                                if selectedOptions.count >= 3 && selectedOptions.count <= 20 {
                                    let recs = smartRecommendations(for: selectedOptions)
                                    if recs.isEmpty {
                                        whatIHaveRecommendations = ["We couldn't detect a clear investment style. Try selecting more focused items."]
                                    } else {
                                        whatIHaveRecommendations = recs
                                    }
                                    showWhatIHaveResult = true
                                }
                            }) {
                                Text("Submit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(selectedOptions.count >= 3 && selectedOptions.count <= 20 ? accentPurple : Color.gray)
                                    .cornerRadius(12)
                                    .shadow(color: accentPurple.opacity(0.18), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .disabled(selectedOptions.count < 3 || selectedOptions.count > 20)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Wallet Save", isPresented: $showSaveResult) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveResultMessage)
            }
            .onAppear {
                fetchWalletFromDatabase()
            }
        }
    }
}
