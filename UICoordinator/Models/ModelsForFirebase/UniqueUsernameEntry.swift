//
//  UniqueUsernameEntry.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/06/2025.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct UniqueUsernameEntry: Codable, Hashable, Equatable {
    
    let userId: String
    var time: Timestamp?
    
}
