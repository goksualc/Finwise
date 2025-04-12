//
//  LoginView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 4/11/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showSignUp = false
    @State private var showHomeView = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    // Brand Colors
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                // Successfully logged in
                showHomeView = true
                print("Successfully logged in user: \(result?.user.uid ?? "")")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradients
                Color(hex: "1E4B8E").opacity(0.95)
                    .ignoresSafeArea()
                
                VStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [mintGreen.opacity(0.8), lightBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [lightBlue.opacity(0.8), darkBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .offset(x: 100, y: 200)
                    
                    Spacer()
                }
                
                // Content
                VStack(spacing: 30) {
                    // Logo and title
                    VStack(spacing: 15) {
                        Image("AppIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Text("Finwise")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Smart Finance Management")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                    
                    // Login form
                    VStack(spacing: 20) {
                        // Email field
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("", text: $email)
                                .foregroundColor(.white)
                                .placeholder(when: email.isEmpty) {
                                    Text("Email").foregroundColor(.gray)
                                }
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Password field
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            if isSecure {
                                SecureField("", text: $password)
                                    .foregroundColor(.white)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Password").foregroundColor(.gray)
                                    }
                                    .textContentType(.password)
                            } else {
                                TextField("", text: $password)
                                    .foregroundColor(.white)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Password").foregroundColor(.gray)
                                    }
                                    .textContentType(.password)
                            }
                            Button(action: { isSecure.toggle() }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Forgot password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                if !email.isEmpty {
                                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                                        if let error = error {
                                            errorMessage = error.localizedDescription
                                            showError = true
                                        } else {
                                            errorMessage = "Password reset email sent!"
                                            showError = true
                                        }
                                    }
                                } else {
                                    errorMessage = "Please enter your email first"
                                    showError = true
                                }
                            }
                            .foregroundColor(.blue)
                            .font(.subheadline)
                        }
                        
                        // Login button
                        Button(action: {
                            loginUser()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                        }
                        
                        // Sign up
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            Button("Sign Up") {
                                showSignUp = true
                            }
                            .foregroundColor(.blue)
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .navigationDestination(isPresented: $showHomeView) {
                HomeView()
                    .navigationBarBackButtonHidden()
            }
            .alert("Message", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
}

// Extension for hex color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LoginView()
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
