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
    
    func createActivity(name: String) async throws -> Activity? {
        guard let currentUserId = CurrentUserService.sharedCurrent.currentUser?.id else { return nil }
        
        let activityNew = Activity(ownerUid: currentUserId, name: name, typeActivity: .travel, description: "", time: Timestamp(), status: true, likes: 0, locationsId: [])
        
        try await ActivityService.uploadedActivity(activityNew)
        
        let act = try await ActivityService.fitchActivity(time: activityNew.time)
        
        return act
    }
    
    private func fetchFollowersActivity() async throws {
        
        self.activities = []
        let users = await localUserServise.fetchUsersbyLocalUsers()
        var followersId = users.map({ $0.id })
        followersId.removeAll(where: { $0 == CurrentUserService.sharedCurrent.currentUser?.id })
        self.activities = try await ActivityService.fitchActivities(usersId: followersId)
        
        try await fetchUserForActivity(users: users)
        
    }
    
    private func fetchMyActivity() async throws {
        
        guard let currentUser = CurrentUserService.sharedCurrent.currentUser else { return }
        self.activities = []
        self.activities = try await ActivityService.fetchCurrentUserActivity()
        
        for i in activities.indices {
            activities[i].user = currentUser
        }
        
    }
    
    private func fetchUserForActivity(users: [User]) async throws {
        
        for i in 0 ..< activities.count {
            let activity = activities[i]
            var activityUser = users.first(where: { $0.id == activity.ownerUid })
            if activityUser == nil {
                activityUser = await userService.fetchUser(withUid: activity.ownerUid)
            }
            activities[i].user = activityUser
        }
    }
    
    private func fetchLikeActivity() async throws {
        
        let likes = try await LikeService.fetchLikeCurrentUsers(collectionName: "ActivityLikes")
        self.activities = []
        let users = await localUserServise.fetchUsersbyLocalUsers()
        
        for like in likes {
            let activity = try await ActivityService.fitchActivity(documentId: like.colloquyId)
            self.activities.append(activity)
        }
        
        try await fetchUserForActivity(users: users)
    }
    
    func fetchActivity(typeActivity: PropertyTypeActivity) async throws {
        
        switch typeActivity {
        case .myActivity:
            Task {
                try await fetchMyActivity()
            }
        case .likeActivity:
            Task {
                try await fetchLikeActivity()
            }
        case .followerActivity:
            Task {
                try await fetchFollowersActivity()
            }
        }
    }
    
}
