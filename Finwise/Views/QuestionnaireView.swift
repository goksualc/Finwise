import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct QuestionnaireView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var age = ""
    @State private var gold = ""
    @State private var bond = ""
    @State private var cash = ""
    @State private var stocks = ""
    @State private var financialGoals = ""
    @State private var timelineForGoals = ""
    @State private var monthlyExpenses = ""
    @State private var existingInvestments = ""
    @State private var selectedInvestmentTypes: Set<UserProfile.InvestmentType> = []
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showPsychologicalQuestionnaire = false
    @State private var acceptedKVKK = false
    
    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    
    private func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not found"
            showError = true
            return
        }
        
        guard let ageInt = Int(age),
              let goldDouble = Double(gold),
              let bondDouble = Double(bond),
              let cashDouble = Double(cash),
              let stocksDouble = Double(stocks),
              let monthlyExpensesDouble = Double(monthlyExpenses) else {
            errorMessage = "Please enter valid numbers"
            showError = true
            return
        }
        
        isLoading = true
        
        let profile = UserProfile(
            userId: userId,
            age: ageInt,
            gold: goldDouble,
            bond: bondDouble,
            cash: cashDouble,
            stocks: stocksDouble,
            financialGoals: financialGoals.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            timelineForGoals: timelineForGoals,
            monthlyExpenses: monthlyExpensesDouble,
            existingInvestments: existingInvestments.isEmpty ? nil : existingInvestments,
            investmentPreferences: Array(selectedInvestmentTypes),
            hasCompletedQuestionnaire: false,
            createdAt: Date(),
            emotionalReactivity: nil,
            cognitiveBiases: nil,
            decisionMakingStyle: nil,
            timePreference: nil,
            personalityTraits: nil
        )
        
        let db = Firestore.firestore()
        db.collection("userProfiles").document(userId).setData(profile.toFirestore()) { error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                showPsychologicalQuestionnaire = true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                darkBlue.opacity(0.95)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Profile")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        // Age and Contact Info
                        Group {
                            CustomTextField(text: $age, placeholder: "Age", keyboardType: .numberPad)
                        }
                        
                        // Income Information
                        Group {
                            Text("Assets")
                                .font(.headline)
                                .foregroundColor(.white)
                            CustomTextField(text: $gold, placeholder: "Gold as $", keyboardType: .decimalPad)
                            CustomTextField(text: $bond, placeholder: "Bond as $", keyboardType: .decimalPad)
                            CustomTextField(text: $cash, placeholder: "Cash as $", keyboardType: .decimalPad)
                            CustomTextField(text: $stocks, placeholder: "Stocks as $", keyboardType: .decimalPad)
                        }
                        
                        // Financial Goals
                        Group {
                            Text("Financial Goals")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            CustomTextField(text: $financialGoals, placeholder: "Your goals (separate with commas)")
                            CustomTextField(text: $timelineForGoals, placeholder: "Estimated time to achieve your goals")
                        }
                        
                        // Current Financial Status
                        Group {
                            Text("Current Financial Situation")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            CustomTextField(text: $monthlyExpenses, placeholder: "Your monthly fixed expenses", keyboardType: .decimalPad)
                            CustomTextField(text: $existingInvestments, placeholder: "Your existing investments (if any)")
                        }
                        
                        // Investment Preferences
                        Group {
                            Text("Investment Preferences")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(UserProfile.InvestmentType.allCases, id: \.self) { type in
                                    Toggle(type.rawValue, isOn: Binding(
                                        get: { selectedInvestmentTypes.contains(type) },
                                        set: { isSelected in
                                            if isSelected {
                                                selectedInvestmentTypes.insert(type)
                                            } else {
                                                selectedInvestmentTypes.remove(type)
                                            }
                                        }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: mintGreen))
                                    .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Accept KVKK
                        Toggle(isOn: $acceptedKVKK) {
                            Text("I have read and accept the KVKK (Personal Data Protection Law)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .toggleStyle(CheckboxToggleStyle(tint: mintGreen))
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Save Button
                        Button(action: saveProfile) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Save")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [darkBlue, lightBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .disabled(isLoading || !acceptedKVKK)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("ERROR", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .navigationDestination(isPresented: $showPsychologicalQuestionnaire) {
                PsychologicalQuestionnaireView()
            }
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

extension UserProfile.InvestmentType: CaseIterable {
    static var allCases: [UserProfile.InvestmentType] {
        [.deposit, .mutualFunds, .stocks, .commodities, .crypto, .other]
    }
}

// Custom checkbox toggle style for KVKK
struct CheckboxToggleStyle: ToggleStyle {
    var tint: Color = .accentColor
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? tint : .gray)
                    .font(.title3)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
