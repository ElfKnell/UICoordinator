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
    
    func createActivity(name: String) async throws -> Activity? {
        guard let currentUserId = UserService.shared.currentUser?.id else { return nil }
        
        let activityNew = Activity(ownerUid: currentUserId, name: name, typeActivity: .travel, description: "", time: Timestamp(), status: true, likes: 0, locationsId: [])
        
        try await ActivityService.uploadedActivity(activityNew)
        
        let act = try await ActivityService.fitchActivity(time: activityNew.time)
        
        return act
    }
    
    private func fetchFollowersActivity(followersId: [String]) async throws {
        
        self.activities = try await ActivityService.fitchActivities(usersId: followersId)
        
        try await fetchUserForActivity()
        
    }
    
    private func fetchMyActivity() async throws {
        self.activities = try await ActivityService.fetchCurrentUserActivity()
        
        try await fetchUserForActivity()
        
    }
    
    private func fetchUserForActivity() async throws {
        for i in 0 ..< activities.count {
            let activity = activities[i]
            let userActivity = await UserService.fetchUser(withUid: activity.ownerUid)
            activities[i].user = userActivity
        }
    }
    
    private func fetchLikeActivity() async throws {
        
        let likes = try await LikeService.fetchLikeCurrentUsers(collectionName: "ActivityLikes")
        self.activities = []
        
        for like in likes {
            let activity = try await ActivityService.fitchActivity(documentId: like.colloquyId)
            self.activities.append(activity)
        }
        
        try await fetchUserForActivity()
    }
    
    func fetchActivity(typeActivity: PropertyTypeActivity, followersId: [String]) async throws {
        
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
                try await fetchFollowersActivity(followersId: followersId)
            }
        }
    }
    
}
