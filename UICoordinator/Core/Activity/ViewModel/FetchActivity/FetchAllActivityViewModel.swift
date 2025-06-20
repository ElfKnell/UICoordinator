//
//  FetchAllActivityViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Foundation

class FetchAllActivityViewModel: ObservableObject {
    
    @Published var activities: [Activity] = []
    
    private let pageSize = 10
    private let localUserServise: LocalUserServiceProtocol
    private var fetchingActivities: FetchingActivitiesProtocol
    private var activitySpread: SpreadingActivityProtocol
    
    init(localUserServise: LocalUserServiceProtocol,
         fetchingActivities: FetchingActivitiesProtocol,
         activitySpread: SpreadingActivityProtocol) {
        
        self.localUserServise = localUserServise
        self.fetchingActivities = fetchingActivities
        self.activitySpread = activitySpread
    }
    
    @MainActor
    func refresh(currentUser: User?) async {
        
        activities.removeAll()
        fetchingActivities.clean()
        activitySpread.clean()
        await fetchFollowersActivity(currentUser: currentUser)

    }
    
    @MainActor
    func fetchFollowersActivity(currentUser: User?) async {
        
        var users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        
        users.removeAll(where: { $0 == currentUser })
        
        var activities = await fetchingActivities.fetchActivities(users: users, pageSize: pageSize)
        
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
        self.activities.append(contentsOf: activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() }))

    }

}
