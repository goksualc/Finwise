import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    var userId: String
    var age: Int
    var contactInfo: String
    var monthlyIncome: Double
    var additionalIncome: Double?
    var financialGoals: [String]
    var timelineForGoals: String
    var monthlyExpenses: Double
    var existingInvestments: String?
    var riskTolerance: RiskTolerance
    var investmentPreferences: [InvestmentType]
    var hasCompletedQuestionnaire: Bool
    var createdAt: Date
    
    // Psychological Assessment Fields
    var emotionalReactivity: [String: Int]?
    var cognitiveBiases: [String: Int]?
    var decisionMakingStyle: [String: Int]?
    var timePreference: [String: Int]?
    var personalityTraits: [String: Int]?
    
    enum RiskTolerance: String, Codable {
        case low = "Low (conservative)"
        case medium = "Medium (balanced)"
        case high = "High (aggressive)"

    }
    
    enum InvestmentType: String, Codable {
        case deposit = "Deposit"
        case mutualFunds = "Mutual Funds"
        case stocks = "Stocks"
        case commodities = "Commodities (gold, silver, etc.)"
        case crypto = "Cryptocurrency"
        case other = "Other"

    }
    
    func toFirestore() -> [String: Any] {
        return [
            "userId": userId,
            "age": age,
            "contactInfo": contactInfo,
            "monthlyIncome": monthlyIncome,
            "additionalIncome": additionalIncome as Any,
            "financialGoals": financialGoals,
            "timelineForGoals": timelineForGoals,
            "monthlyExpenses": monthlyExpenses,
            "existingInvestments": existingInvestments as Any,
            "riskTolerance": riskTolerance.rawValue,
            "investmentPreferences": investmentPreferences.map { $0.rawValue },
            "hasCompletedQuestionnaire": hasCompletedQuestionnaire,
            "createdAt": Timestamp(date: createdAt),
            "emotionalReactivity": emotionalReactivity as Any,
            "cognitiveBiases": cognitiveBiases as Any,
            "decisionMakingStyle": decisionMakingStyle as Any,
            "timePreference": timePreference as Any,
            "personalityTraits": personalityTraits as Any
        ]
    }
} 
