//
//  ActivityCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/09/2024.
//

import SwiftUI
import Firebase
import FirebaseCrashlytics
import Foundation

class ActivityCellViewModel: ObservableObject {
    
    @Published var showReplies = false
    @Published var isStread = false
    @Published var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @Published var isRemove = false
    @Published var isError = false
    @Published var errorMessage: String?
    
    private var spreadActivity: SpreadingActivityProtocol
    private var activityUpdate: ActivityUpdateProtocol
    private var deleteActivity: ActivityDeleteProtocol
    
    init(spreadActivity: SpreadingActivityProtocol,
         activityUpdate: ActivityUpdateProtocol,
         deleteActivity: ActivityDeleteProtocol) {
        
        self.spreadActivity = spreadActivity
        self.activityUpdate = activityUpdate
        self.deleteActivity = deleteActivity
    }
    
    @MainActor
    func deleteActivity(activity: Activity) async {
        
        isError = false
        errorMessage = nil
        
        do {
            try await deleteActivity.deleteActivity(activity: activity)
        } catch {
            isError = true
            errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    func isCurrentUser(_ userActivityId: String, currentUser: User?) -> Bool {
        guard let currentUser else { return false }
        return userActivityId == currentUser.id
    }
    
    @MainActor
    func spreadActivity(_ activity: Activity, userId: String?) async {
        
        isError = false
        errorMessage = nil
        
        do {
            
            guard let userId else {
                throw UserError.userIdNil
            }
            
            let spread = Spread(ownerUid: userId, userId: activity.ownerUid, activityId: activity.id, colloquyId: "", time: Timestamp())
            try await spreadActivity.createSpread(spread)
            
            try await activityUpdate.sreadActivity(activity, userId: userId)
            
            isStread = true
            
        } catch {
            isError = true
            errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    func isStread(_ activity: Activity, user: User?) {
        if let userId = user?.id, let spred = activity.spread {
            if spred.contains(userId) {
                isStread = true
            }
        }
    }
}
