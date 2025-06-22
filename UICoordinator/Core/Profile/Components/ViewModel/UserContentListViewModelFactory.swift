//
//  UserContentListViewModelFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/06/2025.
//

import Foundation

struct UserContentListViewModelFactory {
    
    static func make(user: User) -> UserContentListViewModel {
        UserContentListViewModel(
            user: user,
            fetchColloquies: FetchColloquiesFirebase(
                fetchLocation: FetchLocationFromFirebase()),
            fetchReplies: FetchRepliesFirebase(
                fetchLocation: FetchLocationFromFirebase(),
                userService: UserService()),
            localUserServise: LocalUserService())
    }
}
