//
//  Thread.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Colloquy: Identifiable, Codable, Hashable {

    @DocumentID var threadId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    let locationId: String?
    let ownerColloquy: String?
    var repliesCount: Int?
    
    var id: String {
        return threadId ?? NSUUID().uuidString
    }
    
    var user: User?
    var location: Location?
}
