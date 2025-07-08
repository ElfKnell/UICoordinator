//
//  CurrentUserServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation

protocol CurrentUserServiceProtocol {
    
    var currentUser: User? { get set }
    
    func fetchCurrentUser(userId: String?) async throws
    
    func updateCurrentUser() async throws
}
