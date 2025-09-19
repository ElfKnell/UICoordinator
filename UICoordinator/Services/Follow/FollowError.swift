//
//  FollowError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

enum FollowError: Error {
    
    case encodingFailed
    case invalidInput
        
    var description: String {
        switch self {
        case .encodingFailed:
            return "Failed to encode Follow object"
        case .invalidInput:
            return "Invalid input, value is empty"
        }
    }
    
}
