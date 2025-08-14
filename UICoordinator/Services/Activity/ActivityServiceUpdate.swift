//
//  ActivityServiceUpdate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import MapKit
import Firebase
import Foundation

class ActivityServiceUpdate: ActivityUpdateProtocol {
    
    private let collectionName = "Activity"
    
    func updateActivity(_ activity: Activity) async {
        
        do {
            guard let id = activity.activityId else { return }
            
            try await Firestore.firestore()
                .collection(collectionName)
                .document(id)
                .updateData(["name": activity.name,
                             "description": activity.description,
                             "typeActivity": activity.typeActivity.id,
                             "udateTime": Timestamp(),
                             "status": activity.status,
                             "mapStyle" : activity.mapStyle?.id as Any])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateActivityCoordinate(region: MKCoordinateRegion, id: String) async throws {
        
        try await Firestore.firestore()
            .collection(collectionName)
            .document(id)
            .updateData(["latitude": region.center.latitude,
                         "longitude": region.center.longitude,
                         "latitudeDelta": region.span.latitudeDelta,
                         "longitudeDelta": region.span.longitudeDelta])
    }
    
    func updateActivityLocations(locationsId: [String], id: String) async {
        
        do {
            try await Firestore.firestore()
                .collection(collectionName)
                .document(id)
                .updateData(["locationsId": locationsId])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateLikeCount(activityId: String, countLikes: Int) async {
        
        do {
            try await Firestore.firestore()
                .collection(collectionName)
                .document(activityId)
                .updateData(["likes": countLikes])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func incrementRepliesCount(activityId: String) async {
        
        do {
            try await Firestore.firestore()
                .collection(collectionName)
                .document(activityId)
                .updateData(["repliesCount": FieldValue.increment(Int64(1)) ])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func sreadActivity(_ activity: Activity, userId: String) async {
        
        do {
            var userIdSpread: [String] = []
            if let spreads = activity.spread {
                userIdSpread = spreads
            }
            userIdSpread.append(userId)
            
            try await Firestore.firestore()
                .collection(collectionName)
                .document(activity.id)
                .updateData(["spread": userIdSpread])
        } catch {
            print("ERROR update spread activity: \(error.localizedDescription)")
        }

    }
    
}
