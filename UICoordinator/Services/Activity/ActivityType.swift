//
//  ActivityType.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/07/2024.
//

import Foundation

enum ActivityType: Int, Codable, CaseIterable, Identifiable  {
    case track
    case travel
    
    var description: String {
        switch self {
        case .track:
            return "Track"
        case .travel:
            return "Travel"
        }
    }
    
    var id: Int { return self.rawValue }
}
