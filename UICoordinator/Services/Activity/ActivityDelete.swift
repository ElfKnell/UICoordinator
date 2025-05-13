//
//  ActivityDelete.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Firebase
import Foundation

class ActivityDelete: ActivityDeleteProtocol {
    
    let servaceDelete: FirestoreGeneralDeleteProtocol
    
    init(servaceDelete: FirestoreGeneralDeleteProtocol = FirestoreGeneralDeleteService()) {
        
        self.servaceDelete = servaceDelete
    }
    
    func markActivityForDelete(activityId: String) async {
        do {
            
            try await Firestore.firestore()
                .collection("Activity")
                .document(activityId)
                .updateData(["isDelete": true])
            
        } catch {
            print("ERROR spreading activity: \(error.localizedDescription)")
        }
    }
    
    func deleteActivity(activityId: String) async {
        do {
            
            try await self.servaceDelete.deleteDocument(from: "Activity", documentId: activityId)
            
        } catch {
            print("ERROR DELETE FOLLOW: \(error.localizedDescription)")
        }
    }
    
    
}
