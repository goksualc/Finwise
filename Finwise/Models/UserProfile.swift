//
//  UserProfile.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import Foundation
import FirebaseFirestore

extension UserProfile.InvestmentType: CaseIterable {
    static var allCases: [UserProfile.InvestmentType] {
        [.deposit, .mutualFunds, .stocks, .commodities, .crypto, .other]
    }
}

struct UserProfile: Codable {
    var userId: String
    var age: Int
    var gold: Double
    var bond: Double
    var cash: Double
    var stocks: Double
    var financialGoals: [String]
    var timelineForGoals: String
    var monthlyExpenses: Double
    var existingInvestments: String?
    var investmentPreferences: [InvestmentType]
    var hasCompletedQuestionnaire: Bool
    var createdAt: Date
    
    // Psychological Assessment Fields
    var emotionalReactivity: [String: Int]?
    var cognitiveBiases: [String: Int]?
    var decisionMakingStyle: [String: Int]?
    var timePreference: [String: Int]?
    var personalityTraits: [String: Int]?
    
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
            "gold": gold,
            "bond": bond,
            "cash": cash,
            "stocks": stocks,
            "financialGoals": financialGoals,
            "timelineForGoals": timelineForGoals,
            "monthlyExpenses": monthlyExpenses,
            "existingInvestments": existingInvestments as Any,
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
