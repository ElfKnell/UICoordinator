//
//  LikeError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/05/2025.
//

import Foundation

enum LikeError: Error {
    case userIdNil
    
    var value: String {
        switch self {
        case .userIdNil:
            return "User id is nil."
        }
    }
}
