//
//  UserLikeCount.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/06/2024.
//

import Foundation

class UserLikeCount: ObservableObject {
    
    @Published var countLikes = 0
    @Published var usersLike = [User]()
    private var userService = UserService()
    private var fetchingLikes = FetchLikesService(likeRepository: FirestoreLikeRepository())
    
    @MainActor
    func fetchLikes(userId: String) async {
        
        usersLike = []
        let likes = await fetchingLikes.getLikes(collectionName: .likes, byField: .userIdField, userId: userId)
        
        self.countLikes = likes.count
        let usersIdLikes =  Set(likes.map { $0.ownerUid })
        for like in usersIdLikes {
            let user = await userService.fetchUser(withUid: like)
            if user.id == userId { continue }
            usersLike.append(user)
        }
        
    }
}
