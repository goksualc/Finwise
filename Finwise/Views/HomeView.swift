//
//  ContentView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 4/11/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    let onSignOut: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showQuestionnaire = false
    @State private var isLoading = true
    @State private var navigateToLogin = false
    @State private var selectedRiskScore: Int = 30 // Default to Balanced
    @State private var showPortfolioRecommendation = false
    @State private var currentRiskProfileTitle: String? = nil
    @State private var showRiskResult = false
    @State private var riskResultScore: Int = 30
    @State private var showEducation = false
    @State private var showFAQ = false
    @State private var showSocialMedia = false
    @State private var showOtherUsers = false
    @State private var showWallet = false
    @State private var showWhatIHaveResult = false
    @State private var whatIHaveRecommendations: [String] = []
    
    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            onSignOut()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func checkQuestionnaireStatus() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("userProfiles").document(userId).getDocument { document, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            if let document = document, document.exists {
                if let hasCompleted = document.data()?["hasCompletedQuestionnaire"] as? Bool {
                    showQuestionnaire = !hasCompleted
                } else {
                    showQuestionnaire = true
                }
                if let riskScore = document.data()?["riskProfile"] as? Int {
                    currentRiskProfileTitle = RiskProfile.profile(for: riskScore).title
                }
            } else {
                showQuestionnaire = true
            }
        }
    }
    
    private func presentRiskResult() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("userProfiles").document(userId).getDocument { document, error in
            if let document = document, document.exists,
               let score = document.data()? ["riskTotalScore"] as? Int {
                riskResultScore = score
            } else {
                riskResultScore = 30 // fallback
            }
            showRiskResult = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Animated Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header (fixed)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome,")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                            Text(Auth.auth().currentUser?.displayName ?? "User")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: signOut) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(lightBlue.opacity(0.7)))
                        }
                        .accessibilityLabel("Çıkış Yap")
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)

                    // Scrollable content
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Risk Profile Card
                            if let riskTitle = currentRiskProfileTitle {
                                HStack {
                                    Image(systemName: "shield.lefthalf.filled")
                                        .font(.title)
                                        .foregroundColor(accentPurple)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Your Risk Profile")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(riskTitle)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(color: accentPurple.opacity(0.08), radius: 8, x: 0, y: 4)
                                .padding(.horizontal)
                            }

                            // Wallet Card
                            HomeActionCard(
                                title: "Wallet",
                                subtitle: "View your assets and investments.",
                                icon: "wallet.pass.fill",
                                color: mintGreen
                            ) {
                                showWallet = true
                            }
                            .padding(.horizontal)

                            // Main Action Cards
                            VStack(spacing: 18) {
                                HomeActionCard(
                                    title: "View Risk Result",
                                    subtitle: "Review your personal risk profile and recommendations.",
                                    icon: "shield.checkerboard",
                                    color: accentPurple
                                ) {
                                    presentRiskResult()
                                }

                                HomeActionCard(
                                    title: "Portfolio Recommendations",
                                    subtitle: "Investment recommendations based on your risk profile.",
                                    icon: "chart.pie.fill",
                                    color: mintGreen
                                ) {
                                    showPortfolioRecommendation = true
                                }

                                HomeActionCard(
                                    title: "Education Center",
                                    subtitle: "Improve yourself in investment and finance topics.",
                                    icon: "book.closed.fill",
                                    color: lightBlue
                                ) {
                                    showEducation = true
                                }

                                HomeActionCard(
                                    title: "FAQ",
                                    subtitle: "Your questions about investment and the app.",
                                    icon: "questionmark.circle.fill",
                                    color: darkBlue
                                ) {
                                    showFAQ = true
                                }

                                HomeActionCard(
                                    title: "Social Media Accounts",
                                    subtitle: "Follow us on social media.",
                                    icon: "person.2.wave.2.fill",
                                    color: accentPurple
                                ) {
                                    showSocialMedia = true
                                }

                                HomeActionCard(
                                    title: "Other Users",
                                    subtitle: "Browse risk profiles and investments anonymously.",
                                    icon: "person.3.fill",
                                    color: lightBlue
                                ) {
                                    showOtherUsers = true
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                        }
                        .padding(.top, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showPortfolioRecommendation) {
                StockRecommendationView(riskProfile: RiskProfile.profile(for: selectedRiskScore))
            }
            .navigationDestination(isPresented: $showEducation) {
                EducationHomeView()
            }
            .navigationDestination(isPresented: $showFAQ) {
                FAQView()
            }
            .fullScreenCover(isPresented: $showRiskResult) {
                NavigationStack {
                    RiskResultView(totalScore: riskResultScore)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .fullScreenCover(isPresented: $showQuestionnaire) {
                QuestionnaireView()
            }
            .sheet(isPresented: $showSocialMedia) {
                SocialMediaSheet()
            }
            .sheet(isPresented: $showOtherUsers) {
                OtherUsersView()
            }
            .sheet(isPresented: $showWallet) {
                UserWalletView()
            }
            .onAppear {
                checkQuestionnaireStatus()
            }
        }
    }
}

// MARK: - Fancy Card Component
struct HomeActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.08), radius: 8, x: 0, y: 4)
        }
    }
}

struct SocialMediaSheet: View {
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Follow us!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(accentPurple)
                    .padding(.top)
                SocialMediaLinkRow(icon: "logo.instagram", label: "Instagram", url: "https://instagram.com/finwise_app")
                SocialMediaLinkRow(icon: "logo.twitter", label: "Twitter", url: "https://twitter.com/fin__wise")
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Sosyal Medya")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SocialMediaLinkRow: View {
    let icon: String
    let label: String
    let url: String
    var body: some View {
        Button(action: {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.primary)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct OtherUsersView: View {
    struct OtherUser: Identifiable {
        let id = UUID()
        let maskedName: String
        let riskProfile: String
        let investments: [String]
    }
    
    // Realistic names for demonstration
    private let names = [
        "Alp Bazoğlu", "Deniz Yılmaz", "Ece Demir", "Mert Kaya", "Zeynep Aksoy", "Baran Şahin", "Elif Çelik", "Kerem Yıldız", "Seda Aydın", "Burak Güneş",
        "Cemre Korkmaz", "Onur Arslan", "Derya Polat", "Emre Koç", "İrem Özkan", "Sibel Karaca", "Can Tunç", "Melis Er", "Tolga Uçar", "Gizem Sezer"
    ]
    
    // Risk profiles
    private let riskProfiles = [
        "Very Conservative", "Conservative", "Balanced", "Aggressive", "Very Aggressive"
    ]
    
    // Real asset tickers (stocks, ETFs, crypto)
    private let assetPool = [
        "AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "META", "NVDA", "VTI", "VOO", "SPY", "QQQ", "BTC", "ETH", "GOLD", "VYM", "SCHD", "ARKK", "XLF", "XLE", "XLY", "XLI", "XLC", "XLV", "XLP", "XLU", "XLB", "VHT", "VFH", "VNQ", "VIG"
    ]
    
    // Mask a name for privacy (e.g., Alp Bazoğlu → A** B*****)
    private func maskName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        guard parts.count == 2 else { return name }
        let first = parts[0], last = parts[1]
        let maskedFirst = first.prefix(1) + String(repeating: "*", count: max(0, first.count-1))
        let maskedLast = last.prefix(1) + String(repeating: "*", count: max(0, last.count-1))
        return "\(maskedFirst) \(maskedLast)"
    }
    
    // Generate 20 fake users
    private var users: [OtherUser] {
        var result: [OtherUser] = []
        for i in 0..<20 {
            let name = names[i % names.count]
            let masked = maskName(name)
            let risk = riskProfiles.randomElement()!
            let investmentCount = Int.random(in: 3...5)
            let investments = assetPool.shuffled().prefix(investmentCount).map { $0 }
            result.append(OtherUser(maskedName: masked, riskProfile: risk, investments: investments))
        }
        return result
    }
    
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 32))
                        .foregroundColor(lightBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Other Users")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Browse risk profiles and investments anonymously.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(users) { user in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(user.maskedName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Risk Profile: \(user.riskProfile)")
                                    .font(.subheadline)
                                    .foregroundColor(lightBlue)
                                Text("Investments: \(user.investments.joined(separator: ", "))")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: lightBlue.opacity(0.08), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
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
            .navigationTitle("Other Users")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserWalletView: View {
    @State private var selectedTab: WalletTab = .wallet
    enum WalletTab: String, CaseIterable, Identifiable {
        case wallet = "Wallet"
        case whatIHave = "What I Have"
        var id: String { self.rawValue }
    }

    // Dummy data for demonstration; replace with real data from QuestionnaireView
    @State private var assets: [String: Double] = [
        "Cash": 1200.0,
        "Stocks": 3500.0,
        "Bonds": 2000.0,
        "Gold": 800.0
    ]
    @State private var investments: [String] = [
        "Large Value ETF",
        "Tech Growth ETF",
        "Bond ETF",
        "Gold ETF"
    ]
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
            "investments": investments,
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
                            ForEach(assets.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                HStack {
                                    Text(key)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(String(format: "$%.2f", value))
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 4)
                            }
                            Divider().background(mintGreen)
                            Text("Investments")
                                .font(.headline)
                                .foregroundColor(mintGreen)
                            ForEach(investments, id: \.self) { inv in
                                Text("• \(inv)")
                                    .font(.body)
                                    .foregroundColor(.primary)
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
                            .background(
                                NavigationLink(
                                    destination: WhatIHaveView(recommendations: whatIHaveRecommendations),
                                    isActive: $showWhatIHaveResult,
                                    label: { EmptyView() }
                                )
                                .hidden()
                            )
                            Spacer(minLength: 24)
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
        }
    }
}

struct InvestmentOptionCardFancy: View {
    let label: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(isSelected ? color : .gray)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .shadow(color: color.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InvestmentCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let assets: [String]
}

let investmentCategories: [InvestmentCategory] = [
    InvestmentCategory(name: "Technology Stocks", icon: "desktopcomputer", color: .blue, assets: ["AAPL", "GOOGL", "MSFT", "TSLA", "NVDA", "META", "AMD"]),
    InvestmentCategory(name: "Cryptocurrencies", icon: "bitcoinsign.circle.fill", color: .orange, assets: ["BTC", "ETH", "AVAX", "SOL", "DOT", "MATIC", "DOGE"]),
    InvestmentCategory(name: "ETFs & Index Funds", icon: "chart.pie.fill", color: .purple, assets: ["SPY", "QQQ", "VTI", "ARKK", "XLK", "VNQ", "VIG", "SCHD", "VOO"]),
    InvestmentCategory(name: "Energy & Commodities", icon: "flame.fill", color: .red, assets: ["XOM", "CVX", "OIL", "GOLD", "SILVER", "COPPER"]),
    InvestmentCategory(name: "Safe Assets", icon: "shield.lefthalf.filled", color: .teal, assets: ["USD/TRY", "DXY", "T-Bond 10Y", "Mevduat", "VIG"]),
    InvestmentCategory(name: "Consumer Stocks", icon: "cart.fill", color: .green, assets: ["WMT", "KO", "MCD", "SBUX", "TGT"]),
    InvestmentCategory(name: "Health Stocks", icon: "cross.case.fill", color: .pink, assets: ["PFE", "MRK", "UNH", "ABBV"]),
    InvestmentCategory(name: "Transportation & Travel", icon: "airplane", color: .indigo, assets: ["ABNB", "UBER", "FDX", "DAL", "AAL"]),
    InvestmentCategory(name: "Emerging Markets", icon: "globe.americas.fill", color: .mint, assets: ["KWEB", "FXI", "EWZ", "INDA", "TUR", "GREK"])
]

#Preview {
    HomeView(onSignOut: {})
}
