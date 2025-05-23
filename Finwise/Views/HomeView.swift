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
    @Environment(\.dismiss) private var dismiss
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showQuestionnaire = false
    @State private var isLoading = true
    @State private var navigateToLogin = false
    @State private var showRiskProfileSheet = false
    @State private var selectedRiskScore: Int = 30 // Default to Balanced
    @State private var showStockRecommendation = false
    @State private var currentRiskProfileTitle: String? = nil
    
    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToLogin = true
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradients
                darkBlue.opacity(0.95)
                    .ignoresSafeArea()
                
                VStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [mintGreen.opacity(0.8), lightBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [lightBlue.opacity(0.8), darkBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .offset(x: 100, y: 200)
                    
                    Spacer()
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    VStack(spacing: 16) {
                        Text("Welcome, \(Auth.auth().currentUser?.displayName ?? "User")!")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: { showRiskProfileSheet = true }) {
                            Text("Recommended Investments")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 8)
                        
                        NavigationLink(destination: EducationHomeView()) {
                            Text("Eğitim Merkezi")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 8)
                        
                        NavigationLink(destination: FAQView()) {
                            Text("Sıkça Sorulan Sorular")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 16)
                        
                        Button(action: signOut) {
                            Text("Sign Out")
                                .foregroundColor(.white)
                                .padding()
                                .background(lightBlue)
                                .cornerRadius(10)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showStockRecommendation) {
                StockRecommendationView(riskProfile: RiskProfile.profile(for: selectedRiskScore))
            }
            .sheet(isPresented: $showRiskProfileSheet) {
                RiskResultView(totalScore: )
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

#Preview {
    HomeView()
}
