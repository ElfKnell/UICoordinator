//
//  Thread.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Colloquy: Identifiable, Codable, Hashable, Equatable, LikeObject {

    @DocumentID var threadId: String?
    
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    let locationId: String?
    let ownerColloquy: String
    var repliesCount: Int?
    var spreadCount: Int?
    var isDelete: Bool
    
    var id: String {
        return threadId ?? NSUUID().uuidString
    }
    
    var user: User?
    var location: Location?
    
    static func == (lhs: Colloquy, rhs: Colloquy) -> Bool {
        lhs.id == rhs.id &&
        lhs.ownerUid == rhs.ownerUid &&
        lhs.caption == rhs.caption &&
        lhs.timestamp == rhs.timestamp &&
        lhs.likes == rhs.likes &&
        lhs.locationId == rhs.locationId &&
        lhs.ownerColloquy == rhs.ownerColloquy &&
        lhs.repliesCount == rhs.repliesCount &&
        lhs.isDelete == rhs.isDelete
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(ownerUid)
        hasher.combine(caption)
        hasher.combine(timestamp)
        hasher.combine(likes)
        hasher.combine(locationId)
        hasher.combine(ownerColloquy)
        hasher.combine(repliesCount)
        hasher.combine(isDelete)
    }
}
