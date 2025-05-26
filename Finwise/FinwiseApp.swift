//
//  FinwiseApp.swift
//  Finwise

//
//  Created by Göksu Alçınkaya on 4/11/25.//

import SwiftUI
import FirebaseCore

@main
struct FinwiseApp: App {
    @State private var isLoggedIn = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct RootView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        if isLoggedIn {
            NavigationStack {
                HomeView(onSignOut: { isLoggedIn = false })
            }
        } else {
            LoginView(onLogin: { isLoggedIn = true })
        }
    }
}
