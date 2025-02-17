//
//  UserLikeCount.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/06/2024.
//

import Foundation

class UserLikeCount: ObservableObject {
    
    @Published var countLikes = 0
    
    @MainActor
    func fetchLikesCount(userId: String) async throws {
        let likes = try await LikeService.fetchUsersLikes(userId: userId, collectionName: "Likes")
        self.countLikes = likes.count
    }
}
