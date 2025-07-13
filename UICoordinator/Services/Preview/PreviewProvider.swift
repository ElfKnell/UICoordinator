//
//  PreviewProvider.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI
import Firebase

class DeveloperPreview {
    
    static let user = User(id: NSUUID().uuidString, fullname: "Anri Kyr", username: "anky", email: "test@gmail.com", isDelete: false)
    
    static let colloquy = Colloquy(ownerUid: user.id, caption: "", timestamp: Timestamp(), likes: 0, locationId: "", ownerColloquy: "", isDelete: false)
    
    static let location = Location(ownerUid: user.id, name: "", description: "", timestamp: Timestamp(), latitude: 51.5010, longitude: -0.1410, activityId: "")
    
    static let photo = Photo(locationUid: NSUUID().uuidString, timestamp: Timestamp(), photoURL: "")
    
    static let activity = Activity(ownerUid: user.id, name: "No name", typeActivity: .track, description: "", time: Timestamp(), status: false, likes: 0, isDelete: false, locationsId: [])
    
    static let video = Video(locationUid: NSUUID().uuidString, timestamp: Timestamp(), videoURL: "")
}
