//
//  ActivityViewModelFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/06/2025.
//

import Foundation

struct ActivityViewModelFactory {
    
    @MainActor
    static func makeActivityViewModel(for currentUser: User?) -> ActivityViewModel {
        ActivityViewModel(currentUser: currentUser,
                          localUserServise: LocalUserService(),
                          userService: UserService(),
                          fetchingLikes: FetchLikesService(likeRepository: FirestoreLikeRepository()),
                          fetchingActivity: FetchingActivityService())
    }
    
    static func makeFetchAllActivityViewModel() -> FetchAllActivityViewModel {
        FetchAllActivityViewModel(localUserServise: LocalUserService(),
                                  fetchingActivities: FetchingActivitiesService(),
                                  activitySpread: ActivitySpreading(userServise: UserService(), fetchingActivity: FetchingActivityService()))
    }
    
    static func makeFetchMyActivityViewModel(for currentUser: User?) -> FetchMyActivity {
        FetchMyActivity(currentUser: currentUser,
                        fetchingActivities: FetchingActivitiesService())
    }
}
