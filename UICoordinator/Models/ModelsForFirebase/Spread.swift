//
//  Spread.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Spread: Identifiable, Codable, Hashable {
    
    @DocumentID var spreadId: String?
    let ownerUid: String //Who spread it?
    let userId: String //Whose?
    let activityId: String
    let colloquyId: String
    var time: Timestamp
    
    var id: String {
        return spreadId ?? NSUUID().uuidString
    }
    
    var ownerUser: User?
    var user: User?
    var activity: Activity?
    var colloquy: Colloquy?
}
