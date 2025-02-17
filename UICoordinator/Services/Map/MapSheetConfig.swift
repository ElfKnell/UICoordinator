//
//  MapSheetConfig.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import Foundation

enum MapSheetConfig: Int, Identifiable {
    case confirmationLocation
    case locationsDetail
    case locationUpdate
    
    var id: Int {
        self.rawValue
    }
}
