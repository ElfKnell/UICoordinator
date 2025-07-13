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
    let spreadDelete: DeleteSpreadServiceProtocol
    let photoService: PhotoServiceProtocol
    let videoService: VideoServiceProtocol
    
    init(servaceDelete: FirestoreGeneralDeleteProtocol,
         locationDelete: DeleteLocationProtocol,
         likesDelete: LikesDeleteServiceProtocol,
         spreadDelete: DeleteSpreadServiceProtocol,
         photoService: PhotoServiceProtocol,
         videoService: VideoServiceProtocol) {
        
        self.servaceDelete = servaceDelete
        self.locationDelete = locationDelete
        self.likesDelete = likesDelete
        self.spreadDelete = spreadDelete
        self.photoService = photoService
        self.videoService = videoService
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
            
            let photos = try await photoService.fetchPhotosByLocation(activity.id)
            let videos = try await videoService.fetchVideosByLocation(activity.id)
            
            if !photos.isEmpty {
                for photo in photos {
                    try await photoService.deletePhoto(photo: photo)
                }
            }
            
            if !videos.isEmpty {
                for video in videos {
                    try await videoService.deleteVideo(video: video)
                }
            }
            
            await locationDelete.deleteLocations(with: activity.locationsId)
            
            await likesDelete.likesDelete(objectId: activity.id, collectionName: .activityLikes)
            
            try await spreadDelete.removeSpreads(activity.id, withType: .activity)
            
            try await self.servaceDelete.deleteDocument(from: "Activity", documentId: activity.id)
            
        } catch {
            print("ERROR DELETE FOLLOW: \(error.localizedDescription)")
        }
    }
    
    
}
