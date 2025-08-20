//
//  ActivityService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/05/2024.
//

import Foundation
import Firebase

class ActivityCreateService: ActivityCreateProtocol {
    
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate()) {
        self.serviceCreate = serviceCreate
    }
    
    func uploadedActivity(_ activity: Activity) async {
        
        do {
            guard let activityData = try? Firestore.Encoder()
                .encode(activity) else {
                throw ErrorActivity.encodingFailed
            }
            
            try await self.serviceCreate.addDocument(from: "Activity", data: activityData)
            
        } catch {
            print("ERROR CREATE ACTIVITY: \(error.localizedDescription)")
        }
    }

}
