//
//  EducationHomeView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

let educationTopics: [(String, String)] = [
    ("Fon Nedir?", "Fon nedir? Detaylı açıklama..."),
    ("Eurobond Nedir?", "Eurobond nedir? Detaylı açıklama..."),
    ("Altın Yatırımı", "Altın yatırımı nedir? Detaylı açıklama...")
]

struct EducationHomeView: View {
    var body: some View {
        List(educationTopics, id: \.0) { topic in
            NavigationLink(destination: EducationTopicDetailView(title: topic.0, detail: topic.1)) {
                Text(topic.0)
            }
        }
        .navigationTitle("Eğitim Konuları")
    }
}
