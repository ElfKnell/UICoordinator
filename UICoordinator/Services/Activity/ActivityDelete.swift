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
    let routesServise: RouteDeleteServiceProtocol
    let colloquyService: ColloquyServiceProtocol
    
    init(servaceDelete: FirestoreGeneralDeleteProtocol,
         locationDelete: DeleteLocationProtocol,
         likesDelete: LikesDeleteServiceProtocol,
         spreadDelete: DeleteSpreadServiceProtocol,
         photoService: PhotoServiceProtocol,
         videoService: VideoServiceProtocol,
         routesServise: RouteDeleteServiceProtocol,
         colloquyService: ColloquyServiceProtocol) {
        
        self.servaceDelete = servaceDelete
        self.locationDelete = locationDelete
        self.likesDelete = likesDelete
        self.spreadDelete = spreadDelete
        self.photoService = photoService
        self.videoService = videoService
        self.routesServise = routesServise
        self.colloquyService = colloquyService
    }
    
    func deleteActivity(activity: Activity) async throws {
        
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
        
        try await routesServise.deleteByActivity(activityId: activity.id)
        
        try await colloquyService.deleteColloquy(activity)
        
        try await locationDelete.deleteLocations(with: activity.locationsId)
        
        try await likesDelete.likesDelete(objectId: activity.id, collectionName: .activityLikes)
        
        try await spreadDelete.removeSpreads(activity.id, withType: .activity)
        
        try await self.servaceDelete.deleteDocument(from: "Activity", documentId: activity.id)
        
    }
    
    
}
