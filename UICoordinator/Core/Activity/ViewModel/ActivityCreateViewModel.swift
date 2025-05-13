//
//  ActivityCreateViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Firebase
import Foundation

class ActivityCreateViewModel: ObservableObject {
    
    @Published var activity: Activity?
    
    private let createActivity = ActivityCreateService()
    private let fetchingActivity = FetchingActivityService()
    
    func createActivity(name: String, currentUserId: String?) async -> Activity? {
        
        guard let currentUserId else { return nil }
        
        let activityNew = Activity(ownerUid: currentUserId, name: name, typeActivity: .travel, description: "", time: Timestamp(), status: true, likes: 0, isDelete: false, locationsId: [])
        
        await createActivity.uploadedActivity(activityNew)
        
        let act = await fetchingActivity.fetchActivity(time: activityNew.time, userId: currentUserId)
        
        return act
    }
    
}
