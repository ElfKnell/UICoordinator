//
//  ProfileThreadFilter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/02/2024.
//

import Foundation

enum ProfileColloquyFilter: Int, CaseIterable, Identifiable {
    case colloquies
    case replies
    
    var title: String {
        switch self {
        case .colloquies:
            return "Colloquies"
        case .replies:
            return "Replies"
        }
    }
    
    var id: Int { return self.rawValue } 
}
