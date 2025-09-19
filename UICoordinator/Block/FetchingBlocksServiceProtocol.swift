//
//  FetchingBlocksServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation

protocol FetchingBlocksServiceProtocol {
    
    var blocksId: Set<String> { get }
    var blockedsId: Set<String> { get }
    
    func fetchBlockers(_ currentUser: User?) async
    
}
