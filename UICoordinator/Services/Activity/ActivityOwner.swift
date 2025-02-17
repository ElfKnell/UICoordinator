//
//  ActivityOwner.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/07/2024.
//

import Foundation

enum ActivityOwner: Int, Codable, CaseIterable, Identifiable {
    case allUsersActivities
    case currentUserActivities
    case likeActivities
    
    var title: String {
        switch self {
        case .allUsersActivities:
            return "All activity"
        case .currentUserActivities:
            return "My activity"
        case .likeActivities:
            return "Like activity"
        }
    }
    
    var id: Int { return self.rawValue }
}
