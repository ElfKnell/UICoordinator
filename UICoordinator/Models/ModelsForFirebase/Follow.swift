//
//  Follow.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Follow: Identifiable, Codable, Hashable {
    
    @DocumentID var followId: String?
    let follower: String
    let following: String
    let updateTime: Timestamp
    
    var id: String {
        return followId ?? NSUUID().uuidString
    }

}
