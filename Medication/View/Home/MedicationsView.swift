//
//  MedicationsView.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI
import UIKit

struct MedicationsView: View {
    
    @State private var showSearchView = false
    @State private var goToEntryView = false
    
    @StateObject private var viewModel = MedicationListViewModel()
    @ObservedObject var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Header
                HStack {
                    Text("My Medications")
                        .font(.title2.bold())
                        .padding([.top, .horizontal])
                    
                    Spacer()
                    
                    Button(action: {
                        authViewModel.logout()
                        authViewModel.signoutComplete = {
                            goToEntryView = true
                            print("Sign out complete")
                        }
                    }) {
                        Text("Sign Out")
                            .font(.title3.smallCaps())
                    }
                    .padding([.top, .horizontal])
                }
                .padding(.bottom, 30)
                // White rounded background for list
                
                List {
                    if viewModel.medications.isEmpty {
                        Text("No Medications Added")
                            .foregroundColor(.gray)
                            .padding()
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(viewModel.medications.indices, id: \.self) { index in
                            NavigationLink(
                                destination: MedicationDetailView(
                                    drug: viewModel.medications[index]
                                        .toRxConceptProperty()
                                )
                            ) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 1.0, green: 0.89, blue: 0.74))
                                            .frame(width: 40, height: 40)
                                        
                                        Image("icnTray")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.black)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    Text("\(viewModel.medications[index].rxcui) || \(viewModel.medications[index].name)")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .listRowBackground(Color.white)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            withAnimation {
                                viewModel.deleteMedication(at: indexSet)
                            }
                        })
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: .infinity)
                .cornerRadius(20, corners: .allCorners)
                
                Spacer()
                
                // Search button
                Button(action: {
                    showSearchView = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Search Medications")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGray6))
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // For iPad support
        .fullScreenCover(isPresented: $goToEntryView) {
            EntryView()
        }
        .sheet(isPresented: $showSearchView, onDismiss: {
            viewModel.fetchMedications()
        }) {
            SearchMedicationView()
        }
        .onAppear {
            viewModel.fetchMedications()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MedicationsView()
}
