//
//  ActivityCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/09/2024.
//

import SwiftUI
import Firebase
import Foundation

class ActivityCellViewModel: ObservableObject {
    
    @Published var showReplies = false
    @Published var isStread = false
    @Published var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    private var spreadActivity = ActivitySpreading()
    private var activityUpdate = ActivityServiceUpdate()
    private var deleteActivity = ActivityDelete()
    private var deleteLocation = DeleteLocation()
    private var serviceLike = LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                          serviceDetete: FirestoreGeneralDeleteService())
    private var fetchingLikes = FetchLikesService(likeRepository: FirestoreLikeRepository())
    
    func markForDelete(_ activity: Activity) async {
        await deleteActivity.markActivityForDelete(activityId: activity.id)
    }
    
    func deleteActivity(activity: Activity) async {
        
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
        
        await deleteActivity.deleteActivity(activityId: activity.id)
    }
    
    func isCurrentUser(_ userActivityId: String, currentUser: User?) -> Bool {
        guard let currentUser else { return false }
        return userActivityId == currentUser.id
    }
    
    @MainActor
    func spreadActivity(_ activity: Activity, userId: String?) async {
        
        guard let userId else { return }
        
        let spread = Spread(ownerUid: userId, userId: activity.ownerUid, activityId: activity.id, colloquyId: "", time: Timestamp())
        await spreadActivity.createSpread(spread)
        
        await activityUpdate.sreadActivity(activity, userId: userId)
        
        isStread = true
    }
    
    func isStread(_ activity: Activity, user: User?) {
        if let userId = user?.id, let spred = activity.spread {
            if spred.contains(userId) {
                isStread = true
            }
        }
    }
}
