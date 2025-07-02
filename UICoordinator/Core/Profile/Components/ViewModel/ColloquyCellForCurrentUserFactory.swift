//
//  ColloquyCellForCurrentUserFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2025.
//

import Foundation
import SwiftUI

struct ColloquyCellForCurrentUserFactory {
    
    static func make(colloquy: Colloquy, user: User, isDeleted: Binding<Bool>) -> ColloquyCellForCurrentUser {
        let colloquyService = ColloquyServiceViewModel(
            colloquyServise: ColloquyService(
                serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter()),
                repliesFetchingService: FetchRepliesFirebase(
                    fetchLocation: FetchLocationFromFirebase(),
                    userService: UserService())))
        
        let viewModel = LikesViewModel(
            collectionName: .likes,
            likeCount: ColloquyInteractionCounterService(),
            likeService: LikeService(
                serviceCreate: FirestoreLikeCreateServise(),
                serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter())),
            fethingLike: FetchLikesService(
                likeRepository: FirestoreLikeRepository()),
            activityUpdate: ActivityServiceUpdate())
        
        return ColloquyCellForCurrentUser(colloquy: colloquy, user: user, isDeleted: isDeleted, colloquyService: colloquyService, viewModel: viewModel)
    }
}
