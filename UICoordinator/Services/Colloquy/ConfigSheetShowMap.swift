//
//  ConfigSheetShowMap.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2024.
//

import Foundation

enum ConfigSheetShowMap: Int, Identifiable {
    case showMap
    case showCreatColloquy
    case showUserProfileedit
    
    var id: Int {
        self.rawValue
    }
}
