//
//  ActivityCurrentUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Foundation

protocol CheckingForCurrentUserProtocol {
    
    func isOwnerCurrentUser(_ ownerUid: String, currentUser: User?) -> Bool
    
}
