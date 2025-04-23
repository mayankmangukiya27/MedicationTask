//
//  DrugSearchView.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import SwiftUI
import Foundation

struct SearchMedicationView: View {
    @StateObject private var viewModel = DrugSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Medication", text: $viewModel.searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Search Button
                Button(action: {
                    viewModel.searchDrug()
                }) {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Results
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if !viewModel.results.isEmpty {
                    HStack{
                        Text("Search Results")
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    List(viewModel.results) { drug in
                        NavigationLink(destination: MedicationDetailView(drug: drug)) {
                            HStack {
                                Image(systemName: "pills.fill")
                                    .foregroundColor(.orange)
                                    .padding(.trailing, 8)
                                Text("\(drug.rxcui) - \(drug.name)")
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                }
                
                Spacer()
            }
            .navigationTitle("Search Medication")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchMedicationView()
}
