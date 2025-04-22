//
//  CurrentUserServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation

protocol CurrentUserServiceProtocol {
    
    var currentUser: User? { get }
    
    func fetchCurrentUser(userId: String?) async
    
    func updateCurrentUser() async
}
