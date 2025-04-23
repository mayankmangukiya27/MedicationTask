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
    
    var userEmail: String {
        return UserDefaults.standard.string(forKey: "userEmail") ?? ""
    }
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
        fetchMedications()
    }
    
    func fetchMedications() {
        let results = realm.objects(MedicationEntity.self)
            .filter("userEmail == %@", userEmail)
        
        medications = Array(results)
    }
    
    func deleteMedication(at offsets: IndexSet) {
        do {
            try realm.write {
                for index in offsets {
                    let itemToDelete = medications[index]
                    if let object = realm.object(ofType: MedicationEntity.self, forPrimaryKey: itemToDelete.id) {
                        realm.delete(object)
                    }
                }
            }
            fetchMedications() // Refresh list
        } catch {
            print("Error deleting medication: \(error.localizedDescription)")
        }
    }
}
