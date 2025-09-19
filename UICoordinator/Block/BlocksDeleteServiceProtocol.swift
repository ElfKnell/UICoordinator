//
//  BlocksDeleteServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation

protocol BlocksDeleteServiceProtocol {
    
    func deleteBlocksByUser(userId: String) async throws
    
}
