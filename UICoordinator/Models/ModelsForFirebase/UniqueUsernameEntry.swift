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
    
    static func == (lhs: UniqueUsernameEntry, rhs: UniqueUsernameEntry) -> Bool {
        guard lhs.userId == rhs.userId else { return false }
        
        if lhs.time == nil && rhs.time == nil { return true }
        if lhs.time == nil || rhs.time == nil { return false }
        
        let timeDifference = abs(lhs.time!.seconds - rhs.time!.seconds)
        return timeDifference <= 1
    }
}
