import SwiftUI

struct RiskResultView: View {
    let totalScore: Int
    var riskProfile: RiskProfile {
        RiskProfile.profile(for: totalScore)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text(riskProfile.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(riskProfile.color)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text(riskProfile.summary)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Recommended Fund Types:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                ForEach(riskProfile.recommendedFunds, id: \.self) { fund in
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(riskProfile.color)
                        Text(fund)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Text(riskProfile.personalMessage)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                // Navigation action here
            }) {
                Text("View Portfolio Recommendation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(riskProfile.color)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Risk Profile Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
struct RiskResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RiskResultView(totalScore: 10)
            RiskResultView(totalScore: 20)
            RiskResultView(totalScore: 30)
            RiskResultView(totalScore: 40)
            RiskResultView(totalScore: 55)
        }
    }
}
#endif 
