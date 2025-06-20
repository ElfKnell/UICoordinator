//
//  SubscribeOrUnsubscribeProtool.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import SwiftData

protocol SubscribeOrUnsubscribeProtocol {
    
    func subscribed(with user: User, currentUserId: String?) async
    
    func unsubcribed(with user: User, followersCurrentUsers: [Follow]) async
}
