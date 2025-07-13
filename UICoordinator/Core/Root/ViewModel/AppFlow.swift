//
//  AppFlow.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/04/2025.
//

import Foundation

enum AppFlow {
    case loading
    case loggedIn(User)
    case loggedOut
    case deleteUser
}
