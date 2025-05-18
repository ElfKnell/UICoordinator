//
//  ActivityViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/05/2024.
//

import Foundation
import Firebase

@MainActor
class ActivityViewModel: ObservableObject {
    
    @Published var activities = [Activity]()
    
    private var localUserServise = LocalUserService()
    private var userService = UserService()
    private let fetchingLikes = FetchLikesService(likeRepository: FirestoreLikeRepository())
    private let fetchingActivity = FetchingActivityService()
    
    init(currentUser: User?) {
        Task {
            await fetchLikeActivity(currentUser: currentUser)
        }
    }
    
    func fetchLikeActivity(currentUser: User?) async {
        
        let likes = await fetchingLikes.getLikes(collectionName: .activityLikes, byField: .ownerUidField, userId: currentUser?.id)
        
        self.activities = []
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        
        for like in likes {
            var activity = await fetchingActivity.fetchActivity(documentId: like.colloquyId)
            var activityUser = users.first(where: { $0.id == activity.ownerUid })
            if activityUser == nil {
                activityUser = await userService.fetchUser(withUid: activity.ownerUid)
            }
            activity.user = activityUser
            self.activities.append(activity)
        }
    }
}
