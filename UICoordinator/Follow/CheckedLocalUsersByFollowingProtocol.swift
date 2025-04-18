//
//  checkLocalUsersByFollowingProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/04/2025.
//

import Foundation

protocol CheckedLocalUsersByFollowingProtocol {
    func addLocalUsersByFollowingToStore(follows: [String]) async
}
