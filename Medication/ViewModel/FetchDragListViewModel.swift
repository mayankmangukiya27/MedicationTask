//
//  FetchDragListViewModel.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import Foundation
import RealmSwift

class MedicationListViewModel: ObservableObject {
    @Published var medications: [MedicationEntity] = []
    
    private var realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
        fetchMedications()
    }

    func fetchMedications() {
        let results = realm.objects(MedicationEntity.self)
        medications = Array(results)
    }

    func deleteMedication(at offsets: IndexSet) {
        let items = realm.objects(MedicationEntity.self)
        do {
            try realm.write {
                offsets.map { items[$0] }.forEach(realm.delete)
            }
            fetchMedications()
        } catch {
            print("Error deleting medication: \(error.localizedDescription)")
        }
    }
}
