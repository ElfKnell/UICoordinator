//
//  ProfileHeaderFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2025.
//

import Foundation

struct ProfileHeaderFactory {
    
    static func make(user: User) -> ProfileHeaderView {
        let userLikes = UserLikeCount(
            userService: UserService(),
            fetchingLikes: FetchLikesService(
                likeRepository: FirestoreLikeRepository()))
        
        let followToUser = FollowsToUsers(
            localUserServise: LocalUserService(),
            fetchUsers: FetchingUsersServiceFirebase(
                repository: FirestoreUserRepository()))
        
        return ProfileHeaderView(user: user,
                                 userLikes: userLikes,
                                 followToUser: followToUser)
    }
}
