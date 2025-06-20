//
//  LikesDeleteServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/06/2025.
//

import Foundation

protocol LikesDeleteServiceProtocol {
    
    func likesDelete(objectId: String, collectionName: CollectionNameForLike) async
    
}
