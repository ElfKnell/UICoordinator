//
//  UserFollowersProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 27/04/2025.
//

import Foundation

@MainActor
protocol UserFollowersProtocol {
    
    var countFollowers: Int { get set }
    var countFollowing: Int { get set }
    var followingIdsForCurrentUser: [String] { get }
    var followersCurrentUsers: [Follow] { get }

    func loadFollowersCurrentUser(userId: String?) async
    func isFollowingCurrentUser(uid: String) -> Bool
    func updateFollowCounts(for userId: String)
    func clearLocalUsers() async
}
