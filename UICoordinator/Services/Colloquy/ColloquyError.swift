//
//  ColloquyError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 30/08/2025.
//

import Foundation

enum ColloquyError: Error, LocalizedError {
    
    case captionIsEmpty
    
    var errorDescription: String? {
        switch self {
        case .captionIsEmpty:
            return "The text cannot be empty."
        }
    }
    
}
