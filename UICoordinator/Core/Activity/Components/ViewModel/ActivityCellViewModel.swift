//
//  ActivityCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/09/2024.
//

import Foundation

class ActivityCellViewModel: ObservableObject {
    
    func deleteActivity(activity: Activity) async throws {
        
        let likes = try await LikeService.fetchUsersLikes(userId: activity.ownerUid, collectionName: "ActivityLikes")
        
        if !likes.isEmpty {
            for i in 0 ..< likes.count {
                try await LikeService.deleteLike(likeId: likes[i].id, collectionName: "ActivityLikes")
            }
        }
        
        if !activity.locationsId.isEmpty {
            for i in 0 ..< activity.locationsId.count {
                try await LocationService.deleteLocation(locationId: activity.locationsId[i])
            }
        }
        
        try await ActivityService.deleteActivity(activity: activity)
    }
    
}
