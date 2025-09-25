//
//  FetchRepliesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/04/2025.
//

import Foundation

protocol FetchRepliesProtocol {
    
    func getReplies(userId: String, localUsers: [User], pageSize: Int) async throws -> [Colloquy]
    
    func getReplies(
        colloquyId: String,
        localUsers: [User],
        pageSize: Int,
        ordering: Bool) async throws -> [Colloquy]
    
    func getRepliesByColloquy(colloquyId: String) async throws -> [Colloquy]
    
    func reload() async
}
