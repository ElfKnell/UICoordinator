//
//  Photo.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable {
    
    @DocumentID var photoId: String?
    let locationUid: String
    var name: String?
    let timestamp: Timestamp
    let photoURL: String
    var isFlagged: Bool? = false
    
    var id: String {
        return photoId ?? NSUUID().uuidString
    }
    
    var location: Location?
}
