//
//  FirestoreUserRepositoryProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import Foundation

protocol FirestoreUserRepositoryProtocol {
    
    func fetchAllUsers(excluding currentUserId: String) async throws -> [User]
    func fetchUsersByIds(_ ids: [String]) async throws -> [User]
    
}
