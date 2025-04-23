//
//  LoginView.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI

struct LoginView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginToggle = false
    @ObservedObject var viewModel = AuthenticationViewModel()
    @State private var showingAlert = false // Display error message using alert
    @State private var alertMessage = ""
    @State private var goToMedications = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text("Login")
                .font(.title2.bold())
                .foregroundColor(.blue)
                .padding(.top, 40)
                .padding(.bottom)
            
            // Email
            FloatingLabelInput(label: "Email", text: $email, keyboardType: .emailAddress)
                .padding(.top, 8)
            
            // Password Field
            FloatingLabelInput(label: "Create a password", text: $password, isSecure: true)
                .padding(.top, 8)
            
            Spacer()
            
            // Create Account Button
            Button(action: {
                isLoginToggle = true
                viewModel.email = email
                viewModel.password = password
                viewModel.login()
            }) {
                Text("Log In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.bottom, 1)
            
            Button(action: {
                dismiss()
            }) {
                Text("Create Account")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                isLoginToggle = true
            }
        }
        .onChange(of: viewModel.errorMessage) { message in
            if message != nil {
                alertMessage = message!
                showingAlert = true
            } else {
                showingAlert = false
            }
        }
        
        .onAppear(perform: {
            viewModel.loginComplete = { email in
                print("Logged in as \(email)")
                self.goToMedications = true // Trigger navigation
            }
        })
        .fullScreenCover(isPresented: $goToMedications) {
            MedicationsView()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
