//
//  Block.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Block: Identifiable, Codable, Hashable {
    
    @DocumentID var blockId: String?
    let blocker: String
    let blocked: String
    let updateTime: Timestamp
    
    var id: String {
        return blockId ?? NSUUID().uuidString
    }
    
}
