//
//  FAQView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct FAQView: View {
    let faqs = [
        ("Fon nedir?", "Fon, birçok yatırımcının bir araya gelerek oluşturduğu ve profesyonel yöneticiler tarafından yönetilen yatırım aracıdır."),
        ("Eurobond nedir?", "Eurobond, yabancı para cinsinden ihraç edilen uzun vadeli borçlanma aracıdır."),
        // Add more FAQs as needed
    ]

    var body: some View {
        List(faqs, id: \.0) { faq in
            VStack(alignment: .leading, spacing: 8) {
                Text(faq.0)
                    .font(.headline)
                Text(faq.1)
                    .font(.body)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Sıkça Sorulan Sorular")
        // No custom toolbar/back button needed!
    }
}
