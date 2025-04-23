//
//  DrugSearchViewModel.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import Foundation
import Combine
import RealmSwift

class DrugSearchViewModel: ObservableObject {
    @Published var searchText = "cymbalta"
    @Published var results: [RxConceptProperty] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var onComplete: (() -> Void)? = nil

    

    private var cancellables = Set<AnyCancellable>()

    func searchDrug() {
        guard !searchText.isEmpty else { return }

        let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://rxnav.nlm.nih.gov/REST/drugs.json?name=\(query)&expand=psn"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RxDrugResponse.self, decoder: JSONDecoder())
            .map { response in
                response.drugGroup.conceptGroup?
                    .compactMap { $0.conceptProperties }
                    .flatMap { $0 } ?? []
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { drugs in
                self.results = drugs
            }
            .store(in: &cancellables)
    }
    
    func saveToRealm(drug: RxConceptProperty) {
          let realm = try! Realm()
        
        // Check if the rxcui already exists in the database
          if let existingMedication = realm.objects(MedicationEntity.self).filter("rxcui == %@", drug.rxcui).first {
              // If medication already exists, show a Toast message
              showToast(message: "Medication with rxcui \(drug.rxcui) already exists in the database.")
              return
          }
          
          let medication = MedicationEntity()
            medication.rxcui = drug.rxcui
          medication.name = drug.name
          medication.synonym = drug.synonym ?? ""
          medication.psn = drug.psn ?? ""
        medication.tty = drug.tty

          try! realm.write {
              realm.add(medication, update: .modified)
          }

        self.onComplete?()
      }
}
