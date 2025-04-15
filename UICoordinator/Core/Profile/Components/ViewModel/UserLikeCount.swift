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
    
    @MainActor
    func fetchLikes(userId: String) async {
        do {
            usersLike = []
            let likes = try await LikeService.fetchUsersLikes(userId: userId, collectionName: "Likes")
            self.countLikes = likes.count
            let usersIdLikes =  Set(likes.map { $0.ownerUid })
            for like in usersIdLikes {
                let user = await UserService.fetchUser(withUid: like)
                if user.id == userId { continue }
                usersLike.append(user)
            }
        } catch {
            print("ERROR fetch likes: \(error.localizedDescription)")
        }
    }
}
