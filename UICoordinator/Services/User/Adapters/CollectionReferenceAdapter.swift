//
//  CollectionReferenceAdapter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation
import Firebase

class CollectionReferenceAdapter: CollectionReferenceProtocol {
    
    private let collection: CollectionReference
    
    init(collection: CollectionReference) {
        self.collection = collection
    }
    
    func document(_ documentPath: String) -> any DocumentReferenceProtocol {
        return DocumentReferenceAdapter(reference: collection.document(documentPath))
    }
}
