import SwiftUI

@main
struct FinwiseApp: App {
    @State private var isLoggedIn = false

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