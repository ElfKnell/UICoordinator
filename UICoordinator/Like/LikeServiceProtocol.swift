//
//  LikeServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/05/2025.
//

import Foundation

protocol LikeServiceProtocol {
    
    func uploadLike(_ like: Like, collectionName: CollectionNameForLike) async throws
    
    func deleteLike(likeId: String, collectionName: CollectionNameForLike) async throws
    
}
