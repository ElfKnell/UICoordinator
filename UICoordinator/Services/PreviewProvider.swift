//
//  PreviewProvider.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI
import Firebase

class DeveloperPreview {
    
    static let user = User(id: NSUUID().uuidString, fullname: "Anri Kyr", username: "anky", email: "test@gmail.com")
    
    static let thread = Thread(ownerUid: user.id, caption: "", timestamp: Timestamp(), likes: 0)
}
