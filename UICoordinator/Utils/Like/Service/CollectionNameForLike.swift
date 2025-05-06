//
//  CollectionToFetchingLike.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Foundation

enum CollectionNameForLike {
    case likes
    case activityLikes
    
    var value: String {
        switch self {
        case .likes:
            return "Likes"
        case .activityLikes:
            return "ActivityLikes"
        }
    }
}
