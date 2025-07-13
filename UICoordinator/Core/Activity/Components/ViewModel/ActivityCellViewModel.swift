//
//  ActivityCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/09/2024.
//

import SwiftUI
import Firebase
import Foundation

class ActivityCellViewModel: ObservableObject {
    
    @Published var showReplies = false
    @Published var isStread = false
    @Published var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @Published var isRemove = false
    
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
    
    func markForDelete(_ activity: Activity) async {
        await deleteActivity.markActivityForDelete(activityId: activity.id)
    }
    
    func deleteActivity(activity: Activity) async {
        
        await deleteActivity.deleteActivity(activity: activity)
    }
    
    func isCurrentUser(_ userActivityId: String, currentUser: User?) -> Bool {
        guard let currentUser else { return false }
        return userActivityId == currentUser.id
    }
    
    @MainActor
    func spreadActivity(_ activity: Activity, userId: String?) async {
        
        guard let userId else { return }
        
        let spread = Spread(ownerUid: userId, userId: activity.ownerUid, activityId: activity.id, colloquyId: "", time: Timestamp())
        await spreadActivity.createSpread(spread)
        
        await activityUpdate.sreadActivity(activity, userId: userId)
        
        isStread = true
    }
    
    func isStread(_ activity: Activity, user: User?) {
        if let userId = user?.id, let spred = activity.spread {
            if spred.contains(userId) {
                isStread = true
            }
        }
    }
}
