//
//  FetchRepliesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/04/2025.
//

import Foundation

protocol FetchRepliesProtocol {
    
    func getReplies(userId: String, pageSize: Int) async -> [Colloquy]
}
