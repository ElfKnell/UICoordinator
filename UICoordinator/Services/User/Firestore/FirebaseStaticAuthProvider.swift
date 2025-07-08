//
//  FirebaseStaticAuthProvider.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation
import FirebaseAuth

class FirebaseStaticAuthProvider: FirebaseStaticAuthProviderProtocol {
    
    var currentUser: FirebaseUserProtocol? {
        return Auth.auth().currentUser
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
