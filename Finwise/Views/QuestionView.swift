//
//  QuestionView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct QuestionView: View {
    let question: String
    let options: [String]
    let selectedAnswer: Int
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button(action: { onSelect(index) }) {
                    HStack {
                        Text(option)
                            .foregroundColor(.white)
                        Spacer()
                        if selectedAnswer == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}
