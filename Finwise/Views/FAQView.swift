//
//  FAQView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

let faqList: [(question: String, answer: String)] = [
    ("Fon nedir?", "Fon, birçok yatırımcının bir araya gelerek oluşturduğu ve profesyonel yöneticiler tarafından yönetilen yatırım aracıdır."),
    ("Eurobond nedir?", "Eurobond, yabancı para cinsinden ihraç edilen uzun vadeli borçlanma aracıdır.")
]

struct FAQView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Sıkça Sorulan Sorular")
                    .font(.title).bold().padding(.bottom)

                ForEach(faqList, id: \.question) { faq in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(faq.question)
                            .font(.headline)
                        Text(faq.answer)
                            .font(.body)
                    }
                    .padding(.bottom)
                }
            }
            .padding()
        }
    }
}
