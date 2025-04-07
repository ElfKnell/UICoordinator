//
//  ActivityUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/09/2024.
//

import SwiftUI
import Firebase

class ActivityUser {
    
    static func isCurrentUser(_ ownerUid: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        if uid == ownerUid {
            return true
        } else {
            return false
        }
    }
}
