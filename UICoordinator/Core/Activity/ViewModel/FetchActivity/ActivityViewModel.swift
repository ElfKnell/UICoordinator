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
    
    private let localUserServise: LocalUserServiceProtocol
    private let userService: UserServiceProtocol
    private let fetchingLikes: FetchLikesServiceProtocol
    private let fetchingActivity: FetchingActivityProtocol
    
    init(currentUser: User?,
         localUserServise: LocalUserServiceProtocol,
         userService: UserServiceProtocol,
         fetchingLikes: FetchLikesServiceProtocol,
         fetchingActivity: FetchingActivityProtocol) {
        
        self.localUserServise = localUserServise
        self.userService = userService
        self.fetchingLikes = fetchingLikes
        self.fetchingActivity = fetchingActivity
        
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
