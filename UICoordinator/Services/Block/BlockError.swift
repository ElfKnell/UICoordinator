//
//  BlockError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation

enum BlockError: Error, LocalizedError {
    
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
