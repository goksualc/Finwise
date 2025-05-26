import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PsychologicalQuestionnaireView: View {
    @Binding var showQuestionnaire: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var currentSection = 1
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var navigateToRiskResult = false
    @State private var totalScore = 0
    
    // State variables for each section
    @State private var emotionalReactivity = [String: Int]()
    @State private var cognitiveBiases = [String: Int]()
    @State private var decisionMakingStyle = [String: Int]()
    @State private var timePreference = [String: Int]()
    @State private var personalityTraits = [String: Int]()
    
    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    
    private func calculateTotalScore() -> Int {
        let allAnswers = [emotionalReactivity, cognitiveBiases, decisionMakingStyle, timePreference, personalityTraits]
        return allAnswers.flatMap { $0.values }.reduce(0, +)
    }
    
    private func saveResponses() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not found"
            showError = true
            return
        }
        
        isLoading = true
        let db = Firestore.firestore()
        let score = calculateTotalScore()
        db.collection("userProfiles").document(userId).updateData([
            "emotionalReactivity": emotionalReactivity,
            "cognitiveBiases": cognitiveBiases,
            "decisionMakingStyle": decisionMakingStyle,
            "timePreference": timePreference,
            "personalityTraits": personalityTraits,
            "hasCompletedQuestionnaire": true,
            "riskTotalScore": score
        ]) { error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                totalScore = score
                navigateToRiskResult = true
                showQuestionnaire = false
            }
        }
    }
    
    private func answerQuestion(section: String, question: String, answer: Int) {
        switch section {
        case "emotional":
            emotionalReactivity[question] = answer
        case "cognitive":
            cognitiveBiases[question] = answer
        case "decision":
            decisionMakingStyle[question] = answer
        case "time":
            timePreference[question] = answer
        case "personality":
            personalityTraits[question] = answer
        default:
            break
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
                        // Section 1: Emotional Reactivity & Stress Tolerance
                        if currentSection == 1 {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Section 1: Emotional Reactivity & Stress Tolerance")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                QuestionView(
                                    question: "When the market drops significantly in one day, how do you usually react?",
                                    options: [
                                        "I feel the urge to sell everything.",
                                        "I worry but avoid acting impulsively.",
                                        "I analyze the situation and may consider buying.",
                                        "I stay calm and see it as normal volatility."
                                    ],
                                    selectedAnswer: emotionalReactivity["market_drop"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "emotional", question: "market_drop", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "You check your investment and see it has fallen 10%. What thought comes first?",
                                    options: [
                                        "\"I'm terrible at this.\"",
                                        "\"I should've been more careful.\"",
                                        "\"I wonder what caused it.\"",
                                        "\"Is this a buying opportunity?\""
                                    ],
                                    selectedAnswer: emotionalReactivity["investment_fall"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "emotional", question: "investment_fall", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "Do you follow financial news regularly?",
                                    options: [
                                        "No, it makes me anxious.",
                                        "Occasionally, when there's a major event.",
                                        "Yes, a few times per week.",
                                        "Yes, every day and I enjoy it."
                                    ],
                                    selectedAnswer: emotionalReactivity["news_following"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "emotional", question: "news_following", answer: answer)
                                }
                            }
                        }
                        
                        // Section 2: Cognitive Biases & Heuristics
                        if currentSection == 2 {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Section 2: Cognitive Biases & Heuristics")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                QuestionView(
                                    question: "Have you ever held onto a losing investment for too long just to avoid realizing a loss?",
                                    options: [
                                        "Yes, frequently.",
                                        "Sometimes.",
                                        "Rarely.",
                                        "No, I always cut losses when needed."
                                    ],
                                    selectedAnswer: cognitiveBiases["loss_aversion"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "cognitive", question: "loss_aversion", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "After making a profit from a risky investment, how do you usually feel?",
                                    options: [
                                        "Relieved.",
                                        "Lucky.",
                                        "Confident and more willing to take risk.",
                                        "Like I'm in control and skilled."
                                    ],
                                    selectedAnswer: cognitiveBiases["profit_feeling"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "cognitive", question: "profit_feeling", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "How much does herd behavior influence your investing decisions?",
                                    options: [
                                        "A lot – I trust popular opinion.",
                                        "I'm influenced by it, but try to resist.",
                                        "I'm mostly independent.",
                                        "I go against the crowd on purpose."
                                    ],
                                    selectedAnswer: cognitiveBiases["herd_behavior"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "cognitive", question: "herd_behavior", answer: answer)
                                }
                            }
                        }
                        
                        // Section 3: Decision-Making Style
                        if currentSection == 3 {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Section 3: Decision-Making Style")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                QuestionView(
                                    question: "How do you typically make investment decisions?",
                                    options: [
                                        "Based on intuition or feelings.",
                                        "By asking others I trust.",
                                        "Through basic research.",
                                        "Through detailed analysis and comparison."
                                    ],
                                    selectedAnswer: decisionMakingStyle["decision_approach"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "decision", question: "decision_approach", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "What best describes your approach to uncertainty?",
                                    options: [
                                        "I avoid uncertain situations.",
                                        "I'm cautious but open.",
                                        "I embrace uncertainty if there's upside.",
                                        "I thrive in uncertainty and take calculated bets."
                                    ],
                                    selectedAnswer: decisionMakingStyle["uncertainty_approach"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "decision", question: "uncertainty_approach", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "How often do you revisit and revise your investment strategy?",
                                    options: [
                                        "Never – I set it and forget it.",
                                        "Only after big losses.",
                                        "Every few months.",
                                        "Regularly and proactively."
                                    ],
                                    selectedAnswer: decisionMakingStyle["strategy_revision"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "decision", question: "strategy_revision", answer: answer)
                                }
                            }
                        }
                        
                        // Section 4: Time Preference & Delayed Gratification
                        if currentSection == 4 {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Section 4: Time Preference & Delayed Gratification")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                QuestionView(
                                    question: "You're offered two options: A) Get $10,000 now B) Get $15,000 in one year. What do you choose?",
                                    options: [
                                        "Definitely A",
                                        "Probably A",
                                        "Probably B",
                                        "Definitely B"
                                    ],
                                    selectedAnswer: timePreference["money_choice"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "time", question: "money_choice", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "How do you feel about long-term goals (5–10 years ahead)?",
                                    options: [
                                        "Too far, I focus on the present.",
                                        "I struggle to stay committed.",
                                        "I plan for the long-term with some flexibility.",
                                        "I'm disciplined and long-term focused."
                                    ],
                                    selectedAnswer: timePreference["long_term_goals"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "time", question: "long_term_goals", answer: answer)
                                }
                                
                                QuestionView(
                                    question: "If your investments doubled in value tomorrow, what would you most likely do?",
                                    options: [
                                        "Sell all and cash out.",
                                        "Sell a portion.",
                                        "Rebalance the portfolio.",
                                        "Let it ride and stay invested."
                                    ],
                                    selectedAnswer: timePreference["double_value"] ?? -1
                                ) { answer in
                                    answerQuestion(section: "time", question: "double_value", answer: answer)
                                }
                            }
                        }
                        
                        // Section 5: Personality Traits
                        if currentSection == 5 {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Section 5: Personality Traits")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Group {
                                    QuestionView(
                                        question: "I enjoy taking calculated risks in other areas of life (e.g. career, travel, hobbies).",
                                        options: [
                                            "Strongly disagree",
                                            "Disagree",
                                            "Agree",
                                            "Strongly agree"
                                        ],
                                        selectedAnswer: personalityTraits["risk_taking"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "risk_taking", answer: answer)
                                    }
                                    
                                    QuestionView(
                                        question: "I get emotionally affected by financial ups and downs.",
                                        options: [
                                            "Always",
                                            "Often",
                                            "Sometimes",
                                            "Rarely"
                                        ],
                                        selectedAnswer: personalityTraits["emotional_affect"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "emotional_affect", answer: answer)
                                    }
                                }
                                
                                Group {
                                    QuestionView(
                                        question: "I tend to overanalyze decisions before acting.",
                                        options: [
                                            "Strongly agree",
                                            "Agree",
                                            "Disagree",
                                            "Strongly disagree"
                                        ],
                                        selectedAnswer: personalityTraits["overanalysis"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "overanalysis", answer: answer)
                                    }
                                    
                                    QuestionView(
                                        question: "I prefer control and stability over new opportunities.",
                                        options: [
                                            "Strongly agree",
                                            "Agree",
                                            "Disagree",
                                            "Strongly disagree"
                                        ],
                                        selectedAnswer: personalityTraits["control_preference"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "control_preference", answer: answer)
                                    }
                                }
                                
                                Group {
                                    QuestionView(
                                        question: "I believe outcomes in investing are mostly based on:",
                                        options: [
                                            "Luck",
                                            "Market timing",
                                            "Consistency",
                                            "Analysis and discipline"
                                        ],
                                        selectedAnswer: personalityTraits["outcome_belief"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "outcome_belief", answer: answer)
                                    }
                                    
                                    QuestionView(
                                        question: "When I talk about investing, I:",
                                        options: [
                                            "Avoid the topic",
                                            "Keep it private",
                                            "Enjoy discussing ideas",
                                            "Lead conversations and give advice"
                                        ],
                                        selectedAnswer: personalityTraits["investment_discussion"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "investment_discussion", answer: answer)
                                    }
                                }
                                
                                Group {
                                    QuestionView(
                                        question: "I trust automated systems (e.g. robo-advisors) to manage money.",
                                        options: [
                                            "Not at all",
                                            "Only partially",
                                            "Mostly",
                                            "Fully"
                                        ],
                                        selectedAnswer: personalityTraits["automation_trust"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "automation_trust", answer: answer)
                                    }
                                    
                                    QuestionView(
                                        question: "If my portfolio drops 30% during a crisis, my top priority would be:",
                                        options: [
                                            "Selling to stop further loss",
                                            "Contacting a financial advisor",
                                            "Doing independent research",
                                            "Holding or buying more at a discount"
                                        ],
                                        selectedAnswer: personalityTraits["crisis_response"] ?? -1
                                    ) { answer in
                                        answerQuestion(section: "personality", question: "crisis_response", answer: answer)
                                    }
                                }
                            }
                        }
                        
                        // Navigation buttons
                        HStack {
                            if currentSection > 1 {
                                Button(action: { currentSection -= 1 }) {
                                    Text("Previous")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(lightBlue)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Spacer()
                            
                            if currentSection < 5 {
                                Button(action: { currentSection += 1 }) {
                                    Text("Next")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(lightBlue)
                                        .cornerRadius(10)
                                }
                            } else {
                                Button(action: saveResponses) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Submit")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding()
                                .background(lightBlue)
                                .cornerRadius(10)
                                .disabled(isLoading)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToRiskResult) {
                HomeView(onSignOut: {})
                    .navigationBarBackButtonHidden()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
} 
