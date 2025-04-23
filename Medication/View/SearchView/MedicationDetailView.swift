//
//  MedicationDetailView.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI
import RealmSwift
import EventKit

struct MedicationDetailView: View {
    
    let drug: RxConceptProperty
    
    @StateObject private var viewModel = DrugSearchViewModel()
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Medicine Info
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 80, height: 80)
                    Image("icnTray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.black)
                }
                Text(drug.name)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                Text(drug.rxcui)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 10)
            
            // White Card with Details
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Details Header
                    HStack {
                        Text("Details")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.init(top: 15, leading: 12, bottom: 5, trailing: 5))
                    
                    // Details Body
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tablet:")
                            .font(.subheadline.bold())
                        BulletPoint(text: drug.synonym ?? "")
                        BulletPoint(text: drug.tty)
                        
                        Text("Extended Release Tablet:")
                            .font(.subheadline.bold())
                        BulletPoint(text:drug.psn ?? "")
                        
                    }
                    .padding(.init(top: 15, leading: 12, bottom: 5, trailing: 5))
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack{
                Spacer()
                
                Button {
                    addMedicationReminder(drugName: drug.name) { message in
                        toastMessage = message
                        showToast = true
                        
                        // Auto-hide after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                } label: {
                    Image(systemName: "alarm.fill")
                        .frame(width: 25,height: 25)
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding()
                }
                
                
                
            }
            
            // Add to List Button
            Button(action: {
                // Action
                viewModel.saveToRealm(drug: drug)
            }) {
                Text("Add Medication to List")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color(.systemGray6))
        // .ignoresSafeArea()
        .onAppear {
            viewModel.onComplete = {
                toastMessage = "Medication added to your list!"
                showToast = true
                
                // Auto-dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
        
        .overlay(
            VStack {
                Spacer()
                if showToast {
                    ToastMessageView(message: toastMessage)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                        .zIndex(1)
                }
            }
                .animation(.easeIn(duration: 0.3), value: showToast)
        )
    }
    
    func addMedicationReminder(drugName: String, onComplete: @escaping (String) -> Void) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = "Take Medication: \(drugName)"
                event.startDate = Date()
                event.endDate = Date().addingTimeInterval(60 * 5)
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    DispatchQueue.main.async {
                        onComplete("Reminder added to Calendar!")
                    }
                } catch {
                    DispatchQueue.main.async {
                        onComplete("Failed to save calendar event.")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    onComplete("Calendar access denied.")
                }
            }
        }
    }
    
}

// BulletPoint View
struct BulletPoint: View {
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .padding(.top, 3)
            Text(text)
                .font(.body)
                .foregroundColor(.black)
        }
    }
}

struct ToastMessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(.black.opacity(0.85))
            .cornerRadius(10)
            .padding(.horizontal, 16)
    }
}

#Preview {
    //MedicationDetailView(drug: RxConceptProperty)
}

