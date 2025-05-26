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
               let score = document.data()?["riskTotalScore"] as? Int {
                riskResultScore = score
            } else {
                riskResultScore = 30
            }
            
            // Delay showing the view until score is set
            DispatchQueue.main.async {
                showRiskResult = true
            }
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
                                    title: "Other Users",
                                    subtitle: "Browse risk profiles and investments anonymously.",
                                    icon: "person.3.fill",
                                    color: lightBlue
                                ) {
                                    showOtherUsers = true
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
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                        }
                        .padding(.top, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPortfolioRecommendation) {
                StockRecommendationView(riskProfile: RiskProfile.profile(for: selectedRiskScore))
            }
            .sheet(isPresented: $showEducation) {
                NavigationStack {
                    EducationHomeView()
                }
            }
            .sheet(isPresented: $showFAQ) {
                FAQView()
            }
            .fullScreenCover(isPresented: $showRiskResult) {
                NavigationStack {
                    RiskResultView(totalScore: $riskResultScore)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .fullScreenCover(isPresented: $showQuestionnaire) {
                QuestionnaireView(showQuestionnaire: $showQuestionnaire)
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
