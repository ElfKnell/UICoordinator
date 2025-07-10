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
    @Published var errorMessage: String?
    
    private let userService: UserServiceProtocol
    private let fetchingLikes: FetchLikesServiceProtocol
    
    init(userService: UserServiceProtocol, fetchingLikes: FetchLikesServiceProtocol) {
        
        self.userService = userService
        self.fetchingLikes = fetchingLikes
    }
    
    @MainActor
    func fetchLikes(userId: String) async {
        
        usersLike = []
        let likes = await fetchingLikes.getLikes(collectionName: .likes, byField: .userIdField, userId: userId)
        self.errorMessage = nil
        self.countLikes = likes.count
        let usersIdLikes =  Set(likes.map { $0.ownerUid })
        do {
            for like in usersIdLikes {
                let user = try await userService.fetchUser(withUid: like)
                if user.id == userId { continue }
                usersLike.append(user)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
    }
}
