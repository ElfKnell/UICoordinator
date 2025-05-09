//
//  FetchRepliesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/04/2025.
//

import Foundation

protocol FetchRepliesProtocol {
    
    func getReplies(userId: String, localUsers: [User], pageSize: Int) async -> [Colloquy]
    
    func getReplies(colloquyId: String, localUsers: [User], pageSize: Int) async -> [Colloquy]
    
    func getRepliesByColloquy(colloquyId: String) async throws -> [Colloquy]
    
}
