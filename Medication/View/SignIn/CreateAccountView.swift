//
//  CreateAccountView.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI

@available(iOS 13.0, *)
struct CreateAccountView: View {
    @State private var name: String = "" // While you collect name, you aren't saving this anywhere (like Firebase).
    @State private var email: String = ""
    @State private var password = ""
    @State private var isCreateToggle = false  // Controls navigation to MedicationsView
    
    @ObservedObject var viewModel = AuthenticationViewModel()
    
    @State private var showingAlert = false // Display error message using alert
    @State private var alertMessage = ""
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text("Create New Account")
                .font(.title2.bold())
                .foregroundColor(.blue)
                .padding(.top, 40)
                .padding(.bottom, 20)
            
            // Name Field
            FloatingLabelInput(label: "Name", text: $name) // You'll need to provide the implementation for this
                .padding(.top, 3)
            
            // Email Field
            FloatingLabelInput(label: "Email", text: $email, keyboardType: .emailAddress)
                .padding(.top, 8)
            
            // Password Field
            FloatingLabelInput(label: "Create a password", text: $password, isSecure: true)
                .padding(.top, 8)
            
            Spacer()
            
            // Create Account Button
            Button(action: {
                createAccount() // Call the createAccount function here
            }) {
                Text("Create Account")
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
                Text("I already have an account")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
        }
        .padding(.horizontal)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $isCreateToggle) {
            MedicationsView()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true)
        
        // Observe viewModel.isLoggedIn to navigate only when the view model updates it
        .onChange(of: viewModel.isLoggedIn) { newValue in
            if newValue == true {
                if newValue == true {
                    
                    showToast(message: "Account created successfully!")
                    
                    //  Clear input fields
                    name = ""
                    email = ""
                    password = ""
                    
                    // Navigate after a slight delay (optional)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        isCreateToggle = true
                    }
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { message in
            if message != nil {
                alertMessage = message!
                showingAlert = true
                
                if message == "Registration successful!" {
                    // Clear input fields
                    name = ""
                    email = ""
                    password = ""
                    dismiss()
                }
            } else {
                alertMessage = message!
                showingAlert = false
            }
        }
    }
    
    // Use AuthenticationViewModel create function for account creation
    func createAccount() {
        viewModel.email = email
        viewModel.password = password
        viewModel.register()
        
    }
}

#Preview {
    CreateAccountView()
}

