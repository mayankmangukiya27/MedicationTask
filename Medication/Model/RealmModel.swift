//
//  RealmModel.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import Foundation
import RealmSwift

class MedicationEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var rxcui: String = ""
    @Persisted var name: String = ""
    @Persisted var synonym: String = ""
    @Persisted var psn: String = ""
    @Persisted var tty: String = ""
    @Persisted var userEmail: String = ""
    
}

extension MedicationEntity {
    func toRxConceptProperty() -> RxConceptProperty {
            return RxConceptProperty(
                rxcui: self.rxcui,
                name: self.name,
                synonym: self.synonym.isEmpty ? nil : self.synonym,
                tty: self.tty,
                language: "en", // default since not stored in Realm
                suppress: "N",  // default value or logic here
                umlscui: "",    // default/empty string if not stored
                psn: self.psn.isEmpty ? nil : self.psn
            )
    }
}
