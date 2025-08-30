//
//  FetchingUsersServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import Foundation

protocol FetchingUsersServiceProtocol {
    
    func fetchUsers(withId currentUserId: String) async throws -> [User]
    
    func fetchUsersByIds(at ids: [String]) async throws -> [User]
    
}
