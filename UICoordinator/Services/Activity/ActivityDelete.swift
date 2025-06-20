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
    let locationDelete: DeleteLocationProtocol
    let likesDelete: LikesDeleteServiceProtocol
    
    init(servaceDelete: FirestoreGeneralDeleteProtocol = FirestoreGeneralDeleteService(),
         locationDelete: DeleteLocationProtocol,
         likesDelete: LikesDeleteServiceProtocol) {
        
        self.servaceDelete = servaceDelete
        self.locationDelete = locationDelete
        self.likesDelete = likesDelete
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
    
    func deleteActivity(activity: Activity) async {
        
        do {
            await locationDelete.deleteLocations(with: activity.locationsId)
            
            await likesDelete.likesDelete(objectId: activity.id, collectionName: .activityLikes)
            
            try await self.servaceDelete.deleteDocument(from: "Activity", documentId: activity.id)
            
        } catch {
            print("ERROR DELETE FOLLOW: \(error.localizedDescription)")
        }
    }
    
    
}
