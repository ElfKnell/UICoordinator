//
//  UserError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import Foundation

enum UserError: Error {
    case invalidType
    case userNotFound
    
    var description: String {
        switch self {
        case .invalidType:
            return "Invalide type"
        case .userNotFound:
            return "Current user not found"
        }
    }
}
