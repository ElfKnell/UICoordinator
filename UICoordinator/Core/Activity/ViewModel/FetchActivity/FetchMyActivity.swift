//
//  FetchMyActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Foundation

class FetchMyActivity: ObservableObject {
    
    @Published var activities: [Activity] = []
    
    private let pageSize = 7
    private let fetchingActivities: FetchingActivitiesProtocol
    
    init(currentUser: User?, fetchingActivities: FetchingActivitiesProtocol) {
        
        self.fetchingActivities = fetchingActivities
        Task {
            await fetchMyActivity(currentUser: currentUser)
        }
    }
    
    @MainActor
    func refresh(currentUser: User?) async {
        activities.removeAll()
        fetchingActivities.clean()
        await fetchMyActivity(currentUser: currentUser)
    }
    
    @MainActor
    func fetchMyActivity(currentUser: User?) async {
        
        guard let currentUser else { return }
        let activities = await fetchingActivities.fetchActivitiesByUser(user: currentUser,
                                                                         pageSize: pageSize)
        self.activities.append(contentsOf: activities)
        
    }
}
