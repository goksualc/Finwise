//
//  SignUpView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 4/11/25.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSecure = true
    @State private var isConfirmSecure = true
    @State private var errorMessage = ""
    @State private var showError = false
    @Environment(\.dismiss) private var dismiss
    
    func signUpUser() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }
        
        if fullName.isEmpty {
            errorMessage = "Please enter your full name"
            showError = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                // Update display name
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Error updating user profile: \(error.localizedDescription)")
                    }
                }
                // Successfully created user
                print("Successfully created user: \(result?.user.uid ?? "")")
                dismiss() // Return to login view
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "1A1F2C"),
                    Color(hex: "2D3440")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
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
                        
                        Text("Create Your Account")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
                    // Sign up form
                    VStack(spacing: 20) {
                        // Full Name field
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            TextField("", text: $fullName)
                                .foregroundColor(.white)
                                .placeholder(when: fullName.isEmpty) {
                                    Text("Full Name").foregroundColor(.gray)
                                }
                                .textContentType(.name)
                                .autocapitalization(.words)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
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
                                    .textContentType(.newPassword)
                            } else {
                                TextField("", text: $password)
                                    .foregroundColor(.white)
                                    .placeholder(when: password.isEmpty) {
                                        Text("Password").foregroundColor(.gray)
                                    }
                                    .textContentType(.newPassword)
                            }
                            Button(action: { isSecure.toggle() }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Confirm Password field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            if isConfirmSecure {
                                SecureField("", text: $confirmPassword)
                                    .foregroundColor(.white)
                                    .placeholder(when: confirmPassword.isEmpty) {
                                        Text("Confirm Password").foregroundColor(.gray)
                                    }
                                    .textContentType(.newPassword)
                            } else {
                                TextField("", text: $confirmPassword)
                                    .foregroundColor(.white)
                                    .placeholder(when: confirmPassword.isEmpty) {
                                        Text("Confirm Password").foregroundColor(.gray)
                                    }
                                    .textContentType(.newPassword)
                            }
                            Button(action: { isConfirmSecure.toggle() }) {
                                Image(systemName: isConfirmSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        
                        // Terms and conditions
                        HStack(spacing: 4) {
                            Text("By signing up, you agree to our")
                                .foregroundColor(.gray)
                            Button("Terms & Conditions") {
                                // Handle terms and conditions
                            }
                            .foregroundColor(.blue)
                        }
                        .font(.caption)
                        
                        // Sign up button
                        Button(action: {
                            signUpUser()
                        }) {
                            Text("Sign Up")
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
                        
                        // Login
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Button("Login") {
                                dismiss()
                            }
                            .foregroundColor(.blue)
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Message", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    SignUpView()
}
