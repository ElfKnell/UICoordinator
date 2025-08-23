//
//  FirestoreAddDocumentWithID.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import Firebase

class FirestoreAddDocumentWithID: FirestoreAddDocumentWithIDProtocol {
    
    let db = Firestore.firestore()
    
    func setDocument(from collection: String,
                                data: [String : Any],
                                routeID: String) async throws {
        
        try await db
            .collection(collection)
            .document(routeID)
            .setData(data)
        
    }
    
}
