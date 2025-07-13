//
//  SpreadingType.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/07/2025.
//

import Foundation

enum SpreadingType {
    
    case activity
    case colloquy
    
    var value: String {
        switch self {
        case .activity:
            return "activityId"
        case .colloquy:
            return "colloquyId"
        }
    }
}
