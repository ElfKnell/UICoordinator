//
//  ColloquyCellFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/06/2025.
//

import Foundation

struct ColloquyCellFactory {
    
    static func make(colloquy: Colloquy) -> ColloquyCell {
        
        let viewModelLike = LikesViewModel(
            collectionName: .likes,
            likeCount: ColloquyInteractionCounterService(),
            likeService: LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                     serviceDetete: FirestoreGeneralDeleteService()),
            fethingLike: FetchLikesService(likeRepository: FirestoreLikeRepository()),
            activityUpdate: ActivityServiceUpdate())
        
        return ColloquyCell(colloquy: colloquy, viewModelLike: viewModelLike)
    }
}
