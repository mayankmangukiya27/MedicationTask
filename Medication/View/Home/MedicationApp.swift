//
//  MedicationApp.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI
import Firebase

@main
struct MedicationApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            EntryView()
        }
    }
}
