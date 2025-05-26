//
//  EducationHomeView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct EducationHomeView: View {
    let topics = [
           ("What is a Fund?", "A fund is a pooled investment vehicle where money from multiple investors is collected and managed by professionals to invest in a variety of financial instruments such as stocks, bonds, or other assets."),
           ("What is a Eurobond?", "A eurobond is a type of debt security issued in a currency different from the currency of the country or market in which it is issued. They are typically used by governments or corporations to raise capital from international investors."),
           ("Gold Investment", "Gold investment refers to buying gold in physical or financial form (such as gold ETFs or gold stocks) as a way to hedge against inflation and economic uncertainty. It is considered a safe haven asset during market volatility."),
           ("What is a Mutual Fund?", "A mutual fund is a professionally managed investment fund that pools money from multiple investors to purchase securities. It offers diversification and is ideal for passive investors."),
           ("What is an ETF?", "An ETF (Exchange-Traded Fund) is a marketable security that tracks an index, commodity, or asset basket. It trades like a stock and offers liquidity with low expense ratios."),
           ("What is Risk Profiling?", "Risk profiling is the process of determining an individual's willingness and ability to take financial risk. It helps align investment strategies with comfort levels."),
           ("What is Diversification?", "Diversification is an investment strategy that involves spreading investments across various assets to reduce risk. It helps balance potential losses with potential gains."),
           ("What is Inflation?", "Inflation is the rate at which the general level of prices for goods and services rises, reducing purchasing power. Investors often seek assets that outpace inflation."),
           ("What is Compound Interest?", "Compound interest is the process of earning interest on both the original amount of money and on the interest previously earned. It's a key principle in long-term investing."),
           ("What is Asset Allocation?", "Asset allocation refers to distributing your investments among different asset classes like stocks, bonds, and cash. It helps manage risk and align with your financial goals."),
           ("What is a Risk-Averse Investor?", "A risk-averse investor prefers lower returns with known risks over higher returns with unknown risks. They usually favor stable assets like bonds or savings accounts."),
           ("What is Capital Market?", "The capital market is a financial market in which long-term debt or equity-backed securities are bought and sold. It includes the stock market and bond market."),
           ("What are Government Bonds?", "Government bonds are debt securities issued by a government to support public spending. They are considered low-risk and offer fixed interest returns.")
       ]

    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 32))
                        .foregroundColor(mintGreen)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Education Center")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Improve yourself in investment and finance topics.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(topics, id: \.0) { topic in
                            NavigationLink(destination: EducationTopicDetailView(title: topic.0, detail: topic.1)) {
                                EducationTopicCard(title: topic.0, color: mintGreen)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
