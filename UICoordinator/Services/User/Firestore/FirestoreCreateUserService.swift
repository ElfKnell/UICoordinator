//
//  FirestoreCreateUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation
import Firebase

class FirestoreCreateUserService: FirestoreCreateUserProtocol {
    
    func setUserData(id: String, data: [String : Any]) async throws {
        try await Firestore.firestore().collection("users").document(id).setData(data)
    }
    
}
