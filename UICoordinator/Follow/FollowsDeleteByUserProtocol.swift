//
//  FollowsDeleteByUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation

protocol FollowsDeleteByUserProtocol {
    
    func deleteFollowsByUser(userId: String) async throws
    
    func deleteFollowRelationship(curentUserId: String, userId: String) async throws
    
}
