//
//  FieldToFetchingLike.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Foundation

enum FieldToFetchingLike {
    
    case ownerUidField
    case userIdField
    
    var value: String {
        switch self {
        case .ownerUidField:
            return "ownerUid"
        case .userIdField:
            return "userId"
        }
    }
}
