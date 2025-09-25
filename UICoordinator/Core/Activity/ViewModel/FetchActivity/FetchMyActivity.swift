//
//  FetchMyActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Foundation
import FirebaseCrashlytics

class FetchMyActivity: ObservableObject {
    
    @Published var isError = false
    @Published var errorMessage: String?
    @Published var activities: [Activity] = []
    
    private let pageSize = 7
    private let fetchingActivities: FetchingActivitiesProtocol
    
    init(currentUser: User?, fetchingActivities: FetchingActivitiesProtocol) {
        
        self.fetchingActivities = fetchingActivities

    }
    
    @MainActor
    func refresh(currentUser: User?) async {
        activities.removeAll()
        await fetchingActivities.clean()
        await fetchMyActivity(currentUser: currentUser)
    }
    
    @MainActor
    func fetchMyActivity(currentUser: User?) async {
        
        self.isError = false
        self.errorMessage = nil
        
        do {
            
            guard let currentUser else { return }
            let activities = try await fetchingActivities
                .fetchActivitiesByUser(user: currentUser,
                                       pageSize: pageSize)
            self.activities.append(contentsOf: activities)
            
        } catch {
            self.isError = true
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
