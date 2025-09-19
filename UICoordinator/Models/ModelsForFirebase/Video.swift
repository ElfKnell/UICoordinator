//
//  Video.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Video: Identifiable, Codable {
    
    @DocumentID var videoId: String?
    let locationUid: String
    var title: String?
    let timestamp: Timestamp
    let videoURL: String
    var isFlagged: Bool? = false
    
    var id: String {
        return videoId ?? NSUUID().uuidString
    }
    
    var location: Location?
}
