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

    var storedEmail: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }
    
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
        
        .fullScreenCover(isPresented: $goToMedication) {
            if storedEmail != ""  {
                   MedicationsView()
                       .transition(.identity)
            } else {
                ContentView()
            }
            
        }
        .navigationBarBackButtonHidden()
    }
}
