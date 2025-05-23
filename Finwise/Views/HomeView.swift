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
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hoşgeldin,")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                            Text(Auth.auth().currentUser?.displayName ?? "Kullanıcı")
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

                    Spacer().frame(height: 24)

                    // Risk Profile Card
                    if let riskTitle = currentRiskProfileTitle {
                        HStack {
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.title)
                                .foregroundColor(accentPurple)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Risk Profilin")
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
                        .padding(.bottom, 8)
                    }

                    // Main Action Cards
                    VStack(spacing: 18) {
                        HomeActionCard(
                            title: "Risk Sonucunu Gör",
                            subtitle: "Kişisel risk profilini ve önerileri incele.",
                            icon: "shield.checkerboard",
                            color: accentPurple
                        ) {
                            presentRiskResult()
                        }

                        HomeActionCard(
                            title: "Portfolyo Önerileri",
                            subtitle: "Risk profiline göre yatırım önerileri al.",
                            icon: "chart.pie.fill",
                            color: mintGreen
                        ) {
                            showPortfolioRecommendation = true
                        }

                        HomeActionCard(
                            title: "Eğitim Merkezi",
                            subtitle: "Yatırım ve finans konularında kendini geliştir.",
                            icon: "book.closed.fill",
                            color: lightBlue
                        ) {
                            showEducation = true
                        }

                        HomeActionCard(
                            title: "Sıkça Sorulan Sorular",
                            subtitle: "Yatırım ve uygulama hakkında merak ettiklerin.",
                            icon: "questionmark.circle.fill",
                            color: darkBlue
                        ) {
                            showFAQ = true
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()
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

#Preview {
    HomeView(onSignOut: {})
}
