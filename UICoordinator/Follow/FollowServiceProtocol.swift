//
//  FollowServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/06/2025.
//

import Foundation

protocol FollowServiceProtocol {
    
    func uploadeFollow(_ follow: Follow) async
    
    func deleteFollow(followId: String) async
    
}
