//
//  DeleteCurrentUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation

protocol DeleteCurrentUserProtocol {
    
    func deleteUser(currentUser: User?,
                    userSession: FirebaseUserProtocol?) async throws
    
}
