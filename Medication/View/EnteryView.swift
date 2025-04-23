//
//  EnteryView.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import SwiftUI

struct EntryView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isCheckingAuth = true
    @State private var goToMedication = true
    @State private var delayDone = false

    
    var body: some View {
        NavigationStack {
            if isCheckingAuth {
                ProgressView("Checking login...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isCheckingAuth = false
                        }
                    }
            } else {
                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                delayDone = true
                goToMedication = true
            }
        }
        .fullScreenCover(isPresented: $goToMedication) {
            if viewModel.isLoggedIn {
                   MedicationsView()
                       .transition(.identity)
               } else if delayDone {
                   ContentView()
               } else {
                   EmptyView() // Prevent flicker before delay
               }
            
        }
        .navigationBarBackButtonHidden()
    }
}
