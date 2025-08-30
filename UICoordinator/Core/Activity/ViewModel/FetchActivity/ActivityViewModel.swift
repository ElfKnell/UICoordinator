//
//  ActivityViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/05/2024.
//

import Foundation
import Firebase
import FirebaseCrashlytics

@MainActor
class ActivityViewModel: ObservableObject {
    
    @Published var activities = [Activity]()
    @Published var errorMessage: String?
    
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
    
    @MainActor
    func fetchLikeActivity(currentUser: User?) async {
        
        self.errorMessage = nil
        self.activities = []
        
        do {
            
            let likes = try await fetchingLikes
                .getLikes(collectionName: .activityLikes,
                          byField: .ownerUidField,
                          userId: currentUser?.id)
            
            let users = try await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
            
            for like in likes {
                var activity = try await fetchingActivity.fetchActivity(documentId: like.colloquyId)
                var activityUser = users.first(where: { $0.id == activity.ownerUid })
                if activityUser == nil {
                    activityUser = try await userService.fetchUser(withUid: activity.ownerUid)
                }
                activity.user = activityUser
                self.activities.append(activity)
            }
            
        } catch {
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
