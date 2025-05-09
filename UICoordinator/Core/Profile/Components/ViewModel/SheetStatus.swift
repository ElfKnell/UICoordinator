//
//  SheetStatus.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/05/2025.
//

import Foundation

enum SheetStatus: Int, Identifiable {
    
    case reply
    case location
    
    var id: Int {
        self.rawValue
    }
}
