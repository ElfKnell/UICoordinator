//
//  ActivityCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/09/2024.
//

import Foundation

class ActivityCellViewModel: ObservableObject {
    
    private var deleteLocation = DeleteLocation()
    private var serviceLike = LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                          serviceDetete: FirestoreGeneralDeleteService())
    private var fetchingLikes = FetchLikesService(likeRepository: FirestoreLikeRepository())
    
    func deleteActivity(activity: Activity) async throws {
        
        let likes = await fetchingLikes.getLikes(collectionName: .activityLikes, byField: .userIdField, userId: activity.ownerUid)
        
        if !likes.isEmpty {
            for i in 0 ..< likes.count {
                await serviceLike.deleteLike(likeId: likes[i].id, collectionName: .activityLikes)
            }
        }
        
        if !activity.locationsId.isEmpty {
            for i in 0 ..< activity.locationsId.count {
                await deleteLocation.deleteLocation(at: activity.locationsId[i])
            }
        }
        
        try await ActivityService.deleteActivity(activity: activity)
    }
    
}
