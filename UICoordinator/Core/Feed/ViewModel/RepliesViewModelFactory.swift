//
//  RepliesViewModelFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/06/2025.
//

import Foundation

struct RepliesViewModelFactory {
    
    static func makeRepliesViewModel(_ cid: String, currentUser: User?, isOrdering: Bool) -> RepliesViewModel {
        RepliesViewModel(cid, currentUser: currentUser,
                         isOrdering: isOrdering,
                         fetchRepliesFirebase: FetchRepliesFirebase(
                            fetchLocation: FetchLocationFromFirebase(),
                            userService: UserService()),
                         localUserServise: LocalUserService())
    }
}
