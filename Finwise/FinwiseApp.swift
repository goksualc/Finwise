//
//  FinwiseApp.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 4/11/25.
//

import SwiftUI
import FirebaseCore

@main
struct FinwiseApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RiskResultView(totalScore: 30)
        }
    }
}
