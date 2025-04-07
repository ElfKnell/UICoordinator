//
//  ActivityService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/05/2024.
//

import Foundation
import Firebase
import MapKit

class ActivityService {
    
    static func uploadedActivity(_ activity: Activity) async throws {
        guard let activityData = try? Firestore.Encoder().encode(activity) else { return }
        try await Firestore.firestore().collection("Activity").addDocument(data: activityData)
    }
    
    static func fitchActivities(usersId: [String]) async throws -> [Activity] {
        
        if usersId.isEmpty { return [] }
        let snapshot = try await Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", in: usersId)
            .getDocuments()
        
        let activitys = snapshot.documents.compactMap({ try? $0.data(as: Activity.self)})
        return activitys.sorted(by: { $0.time.dateValue() < $1.time.dateValue() })
    }
    
    static func fitchActivity(documentId: String) async throws -> Activity {
        let snapshot = try await Firestore.firestore().collection("Activity").document(documentId).getDocument()
        return try snapshot.data(as: Activity.self)
    }
    
    static func fetchCurrentUserActivity() async throws -> [Activity] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap({ try? $0.data(as: Activity.self)})
        return activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })
    }
    
    static func updateActivity(_ activity: Activity) async throws {
        
        do {
            guard let id = activity.activityId else { return }
            
            try await Firestore.firestore()
                .collection("Activity")
                .document(id)
                .updateData(["name": activity.name, "description": activity.description, "typeActivity": activity.typeActivity.id, "udateTime": Timestamp(), "status": activity.status, "mapStyle" : activity.mapStyle?.id as Any])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func updateActivityCoordinate(region: MKCoordinateRegion, id: String) async throws {
        
        do {
            try await Firestore.firestore()
                .collection("Activity")
                .document(id)
                .updateData(["latitude": region.center.latitude, "longitude": region.center.longitude, "latitudeDelta": region.span.latitudeDelta, "longitudeDelta": region.span.longitudeDelta])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func updateActivityLocations(locationsId: [String], id: String) async throws {
        
        do {
            try await Firestore.firestore()
                .collection("Activity")
                .document(id)
                .updateData(["locationsId": locationsId])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func fitchActivity(time: Timestamp) async throws -> Activity? {
        
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        let snapshot = try await Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", isEqualTo: uid)
            .whereField("time", isEqualTo: time)
            .getDocuments()
        
        let activity = snapshot.documents.compactMap({ try? $0.data(as: Activity.self)})
        return activity[0]
    }
    
    static func deleteActivity(activity : Activity) async throws {
        try await Firestore
            .firestore()
            .collection("Activity")
            .document(activity.id)
            .delete()
    }
    
    static func updateLikeCount(activityId: String, countLikes: Int) async throws {
        do {
            try await Firestore.firestore()
                .collection("Activity")
                .document(activityId)
                .updateData(["likes": countLikes])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func incrementRepliesCount(activityId: String) async throws {
        do {
            try await Firestore.firestore()
                .collection("Activity")
                .document(activityId)
                .updateData(["repliesCount": FieldValue.increment(Int64(1)) ])

        } catch {
            print(error.localizedDescription)
        }
    }
}
