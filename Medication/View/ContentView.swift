//
//  ContentView.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isCreateAccount = false
    @State private var isLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Logo
                Image("Logo", bundle: nil)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(
                        .blue.opacity(0.6),
                        .blue
                    )
                    .background(Color.clear)
                
                Spacer()
                
                // Create Account Button
                NavigationLink(destination: CreateAccountView()) {
                    Text("Create New Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
             
                // Already have account (Push Navigation)
                NavigationLink(destination: LoginView()) {
                    Text("I already have an account")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                
                
                Spacer().frame(height: 24)
            }
            .background(Color("BackgroundColor", bundle: nil))
            .ignoresSafeArea()
            
        }}
}

#Preview {
    ContentView()
}
