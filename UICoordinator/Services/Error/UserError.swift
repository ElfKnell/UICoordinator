//
//  UserError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import Foundation

enum LikeError: Error {
    case invalidType
    
    var description: String {
        switch self {
        case .invalidType:
            return "Invalide type"
        }
    }
}
