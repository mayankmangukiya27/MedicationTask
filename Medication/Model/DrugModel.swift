//
//  DrugModel.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import Foundation

struct RxDrugResponse: Decodable {
    let drugGroup: RxDrugGroup
}

struct RxDrugGroup: Decodable {
    let conceptGroup: [RxConceptGroup]?
}

struct RxConceptGroup: Decodable {
    let tty: String?
    let conceptProperties: [RxConceptProperty]?
}

struct RxConceptProperty: Identifiable, Decodable {
    var id: String { rxcui }
    
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String
    let language: String
    let suppress: String
    let umlscui: String
    let psn: String?
}
