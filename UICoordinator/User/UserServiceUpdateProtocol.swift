//
//  UserServiceUpdateProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation
import Firebase
import FirebaseStorage

protocol UserServiceUpdateProtocol {
    
    func updateUserProfile(user: User, image: UIImage?, dataUser: [String: Any]) async throws
    
    func deleteUser(userId: String?) async throws
    
}
