//
//  UserExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Foundation

extension User {
    func toLocalUser() -> LocalUser {
        return LocalUser(
            id: id,
            fullname: fullname,
            username: username,
            email: email,
            profileImageURL: profileImageURL,
            bio: bio,
            link: link,
            isDelete: isDelete
        )
    }
}

extension LocalUser {
    func toFirebaseUser() -> User {
        return User(
            id: id,
            fullname: fullname,
            username: username,
            email: email,
            profileImageURL: profileImageURL,
            bio: bio,
            link: link,
            isDelete: isDelete
        )
    }
}
