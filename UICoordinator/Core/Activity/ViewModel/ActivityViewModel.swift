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
    private let pageSize = 20
    private let collectionName = "Activity"
    private var activitySpread = ActivitySpreading()
    private let fetchingActivity = FetchingActivityService()
    private var fetchingActivities = FetchingActivitiesService()
    
    private func fetchFollowersActivity(currentUser: User?) async {
        
        self.activities = []
        fetchingActivities = FetchingActivitiesService()
        var users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        
        users.removeAll(where: { $0 == currentUser })
        
        var activities = await fetchingActivities.fetchActivities(users: users, pageSize: pageSize)
        
        activitySpread = ActivitySpreading()
        let spreads = await activitySpread.getSpreads(users: users,
                                                      pageSize: pageSize,
                                                      byField: "activityId")
        
        var activitySpreads: [Activity] = []
        for spread in spreads {
            
            if spread.userId != currentUser?.id {
                guard var activity = spread.activity else { return }
                activity.user = spread.user
                activity.spreadUser = spread.ownerUser
                activitySpreads.append(activity)
            }
        }
        
        activities.append(contentsOf: activitySpreads)
        self.activities = activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })

    }
    
    private func fetchMyActivity(currentUser: User?) async {
        
        guard let currentUser else { return }
        self.activities = []
        self.activities = await fetchingActivities.fetchActivitiesByUser(user: currentUser,
                                                                         pageSize: pageSize)
        
    }
    
    private func fetchLikeActivity(currentUser: User?) async {
        
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
    
    func fetchActivity(typeActivity: PropertyTypeActivity, currentUser: User?) async throws {
        
        switch typeActivity {
        case .myActivity:
            Task {
                await fetchMyActivity(currentUser: currentUser)
            }
        case .likeActivity:
            Task {
                await fetchLikeActivity(currentUser: currentUser)
            }
        case .followerActivity:
            Task {
                await fetchFollowersActivity(currentUser: currentUser)
            }
        }
    }
    
}
