//
//  UserServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/04/2025.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUser(withUid uid: String) async -> User
}
