//
//  FetchingActivityServise.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import Firebase
import Foundation

class FetchingActivityService: FetchingActivityProtocol {
    
    func fetchActivity(documentId: String) async throws -> Activity {
        
        let snapshot = try await Firestore.firestore()
            .collection("Activity")
            .document(documentId)
            .getDocument()
        
        return try snapshot.data(as: Activity.self)
        
    }
    
    func fetchActivity(time: Timestamp, userId: String) async throws -> Activity? {
        
        let snapshot = try await Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", isEqualTo: userId)
            .whereField("time", isEqualTo: time)
            .getDocuments()
        
        let activity = snapshot.documents.compactMap({ try? $0.data(as: Activity.self)})
        return activity[0]
        
    }
    
    
}
