//
//  ActivityService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/05/2024.
//

import Foundation
import Firebase
import MapKit

class ActivityCreateService: ActivityCreateProtocol {
    
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate()) {
        self.serviceCreate = serviceCreate
    }
    
    func uploadedActivity(_ activity: Activity) async {
        
        do {
            guard let activityData = try? Firestore.Encoder()
                .encode(activity) else { throw FollowError.encodingFailed }
            
            try await self.serviceCreate.addDocument(from: "Activity", data: activityData)
            
        } catch {
            print("ERROR CREATE ACTIVITY: \(error.localizedDescription)")
        }
    }
    
    
//    func uploadedActivity(_ activity: Activity) async throws {
//        guard let activityData = try? Firestore.Encoder().encode(activity) else { return }
//        try await Firestore.firestore().collection("Activity").addDocument(data: activityData)
//    }

}
