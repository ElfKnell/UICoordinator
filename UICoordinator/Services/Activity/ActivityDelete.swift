//
//  ActivityDelete.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Firebase
import Foundation

class ActivityDelete: ActivityDeleteProtocol {
    
    let serviceDelete: FirestoreGeneralDeleteProtocol
    let locationDelete: DeleteLocationProtocol
    let likesDelete: LikesDeleteServiceProtocol
    let spreadDelete: DeleteSpreadServiceProtocol
    let photoService: PhotoServiceProtocol
    //let videoService: VideoServiceProtocol
    let routesServise: RouteDeleteServiceProtocol
    let colloquyService: ColloquyServiceProtocol
    
    init(serviceDelete: FirestoreGeneralDeleteProtocol,
         locationDelete: DeleteLocationProtocol,
         likesDelete: LikesDeleteServiceProtocol,
         spreadDelete: DeleteSpreadServiceProtocol,
         photoService: PhotoServiceProtocol,
         //videoService: VideoServiceProtocol,
         routesServise: RouteDeleteServiceProtocol,
         colloquyService: ColloquyServiceProtocol) {
        
        self.serviceDelete = serviceDelete
        self.locationDelete = locationDelete
        self.likesDelete = likesDelete
        self.spreadDelete = spreadDelete
        self.photoService = photoService
        //self.videoService = videoService
        self.routesServise = routesServise
        self.colloquyService = colloquyService
    }
    
    func deleteActivity(activity: Activity) async throws {
        
        //let videos = try await videoService.fetchVideosByLocation(activity.id)
        
        try await photoService.deletePhotoByLocation(activity.id)
        
//        if !videos.isEmpty {
//            for video in videos {
//                try await videoService.deleteVideo(video: video)
//            }
//        }
        
        try await routesServise.deleteByActivity(activityId: activity.id)
        
        try await colloquyService.deleteColloquy(activity)
        
        try await locationDelete.deleteLocations(with: activity.locationsId)
        
        try await likesDelete.likesDelete(objectId: activity.id, collectionName: .activityLikes)
        
        try await spreadDelete.removeSpreads(activity.id, withType: .activity)
        
        try await self.serviceDelete.deleteDocument(from: "Activity", documentId: activity.id)
        
    }
    
    func deleteAllActivitiesByUser(userId: String) async throws {
        
        let db = Firestore.firestore()
        
        let snapshot = try await db
            .collection("Activity")
            .whereField("ownerUid", isEqualTo: userId)
            .getDocuments()
        
        guard !snapshot.documents.isEmpty else {
            throw ErrorActivity.activitiesNotFound
        }
        
        let activities = snapshot.documents
            .compactMap({ try? $0.data(as: Activity.self)})
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            for activity in activities {
                
                group.addTask {
                    do {
                        try await self.deleteActivity(activity: activity)
                    } catch {
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
                
            }
            try await group.waitForAll()
        }
        
    }
    
}
