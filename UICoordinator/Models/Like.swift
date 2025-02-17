//
//  Like.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/06/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Like: Identifiable, Codable {
    
    @DocumentID var likeId: String?
    let ownerUid: String
    let userId: String
    let colloquyId: String
    var time: Timestamp
    
    var id: String {
        return likeId ?? NSUUID().uuidString
    }
    
    var user: User?
    var colloquy: Colloquy?
}
