//
//  FieldToFetching.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

enum FieldToFetching {
    case followerField
    case followingField
    
    var value: String {
        switch self {
        case .followerField:
            "follower"
        case .followingField:
            "following"
        }
    }
}
