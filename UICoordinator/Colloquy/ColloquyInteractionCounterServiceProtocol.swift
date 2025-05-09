//
//  ColloquyInteractionCounterServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/05/2025.
//

import Foundation

protocol ColloquyInteractionCounterServiceProtocol {
    
    func updateLikeCount(colloquyId: String, countLikes: Int) async
    
    func incrementRepliesCount(colloquyId: String) async
    
}
