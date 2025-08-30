//
//  ActivityCreateViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Firebase
import FirebaseCrashlytics
import Foundation

class ActivityCreateViewModel: ObservableObject {
    
    @Published var activity: Activity?
    @Published var isError = false
    @Published var errorMessage: String?
    
    private let createActivity: ActivityCreateProtocol
    private let fetchingActivity: FetchingActivityProtocol
    
    init(createActivity: ActivityCreateProtocol,
         fetchingActivity: FetchingActivityProtocol) {
        
        self.createActivity = createActivity
        self.fetchingActivity = fetchingActivity
    }
    
    @MainActor
    func createActivity(name: String, currentUserId: String?) async -> Activity? {
        
        isError = false
        errorMessage = nil
        
        do {
            
            guard let currentUserId else {
                throw UserError.userNotFound
            }
            
            if name == "" {
                throw ErrorActivity.nameNil
            }
            
            let activityNew = Activity(ownerUid: currentUserId, name: name, typeActivity: .travel, description: "", time: Timestamp(), status: true, likes: 0, isDelete: false, locationsId: [])
            
            try await createActivity.uploadedActivity(activityNew)
            
            let act = try await fetchingActivity.fetchActivity(time: activityNew.time, userId: currentUserId)
            
            return act
            
        } catch {
            
            isError = true
            errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
            
            return nil
            
        }
    }
    
}
