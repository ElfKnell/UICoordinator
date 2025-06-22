//
//  ColloquyServiceViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2025.
//

import Foundation

class ColloquyServiceViewModel: ObservableObject {
    let colloquyServise: ColloquyServiceProtocol
    
    init(colloquyServise: ColloquyServiceProtocol) {
        self.colloquyServise = colloquyServise
    }
    
    func deleteColloquy(_ colloquyId: String) {
        Task {
            await colloquyServise.markForDelete(colloquyId)
        }
    }
}
