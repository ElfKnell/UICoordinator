//
//  FetchColloquiesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/04/2025.
//

import Foundation

protocol FetchColloquiesProtocol {
    
    func getColloquies(users: [User], pageSize: Int) async throws -> [Colloquy]
    
    func getUserColloquies(user: User, pageSize: Int) async throws -> [Colloquy]
    
    func reload()
}
