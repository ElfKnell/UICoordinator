//
//  ActivityUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/09/2024.
//

import SwiftUI
import Firebase

class CheckingForCurrentUser {
    
    static func isOwnerCurrentUser(_ ownerUid: String, currentUser: User?) -> Bool {
        guard let currentUser else { return false }
        return currentUser.id == ownerUid
    }
}
