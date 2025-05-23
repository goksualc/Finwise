//
//  RiskProfile.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct RiskProfile {
    let title: String
    let summary: String
    let recommendedFunds: [String]
    let personalMessage: String
    let color: Color
    
    static func profile(for score: Int) -> RiskProfile {
        switch score {
        case 0...12:
            return RiskProfile(
                title: "Very Conservative Investor",
                summary: "You prefer safety and capital preservation over high returns. Your focus is on minimizing risk and avoiding losses.",
                recommendedFunds: ["Government Bond Funds", "Money Market Funds", "Short-Term Bond Funds"],
                personalMessage: "A steady approach suits you best. Consider regular reviews to ensure your investments remain low risk.",
                color: .blue
            )
        case 13...24:
            return RiskProfile(
                title: "Conservative Investor",
                summary: "You are cautious but open to some growth. You value stability and are willing to accept limited risk for modest returns.",
                recommendedFunds: ["Bond Funds", "Conservative Allocation Funds", "Dividend Funds"],
                personalMessage: "Balance is key. Diversify with a tilt toward safety, but don't shy away from small growth opportunities.",
                color: .teal
            )
        case 25...36:
            return RiskProfile(
                title: "Balanced Investor",
                summary: "You seek a mix of growth and stability. You are comfortable with moderate risk for the potential of higher returns.",
                recommendedFunds: ["Index Funds", "Balanced Funds", "Large Cap Equity Funds"],
                personalMessage: "A diversified portfolio can help you achieve your goals. Review your allocations as your needs change.",
                color: .green
            )
        case 37...48:
            return RiskProfile(
                title: "Aggressive Investor",
                summary: "You are growth-oriented and willing to accept significant risk for higher returns. You can tolerate market ups and downs.",
                recommendedFunds: ["Equity Funds", "International Funds", "Sector Funds"],
                personalMessage: "Stay focused on your long-term goals, but be mindful of volatility. Regularly reassess your risk tolerance.",
                color: .orange
            )
        case 49...60:
            return RiskProfile(
                title: "Very Aggressive Investor",
                summary: "You thrive on risk and pursue maximum growth. You are comfortable with large fluctuations in your portfolio value.",
                recommendedFunds: ["Emerging Market Funds", "Small Cap Funds", "Thematic/Innovation Funds"],
                personalMessage: "Your bold approach can yield high rewards, but remember to periodically secure gains and manage risk.",
                color: .red
            )
        default:
            return RiskProfile(
                title: "Unknown",
                summary: "Score out of range.",
                recommendedFunds: [],
                personalMessage: "Please retake the risk assessment.",
                color: .gray
            )
        }
    }
}
