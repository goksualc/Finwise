//
//  EducationTopicDetailView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct EducationTopicDetailView: View {
    let title: String
    let detail: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Text(detail)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(title)
    }
}
