//
//  FirestoreCreateUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation

protocol FirestoreCreateUserProtocol {
    
    func createUserWithUniqueUsername(user: User, username: String) async throws
    
}
