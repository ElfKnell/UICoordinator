//
//  ColloquyServiceViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2025.
//

import Foundation
import FirebaseCrashlytics

class ColloquyServiceViewModel: ObservableObject {
    
    @Published var isRemove = false
    @Published var isError = false
    @Published var messageError: String?
    
    let colloquyServise: ColloquyServiceProtocol
    
    init(colloquyServise: ColloquyServiceProtocol) {
        self.colloquyServise = colloquyServise
    }
    
    @MainActor
    func deleteColloquy(_ colloquy: Colloquy) async {
        
        isError = false
        messageError = nil
        
        do {
            try await colloquyServise.deleteColloquy(colloquy)
        } catch {
            isError = true
            messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
