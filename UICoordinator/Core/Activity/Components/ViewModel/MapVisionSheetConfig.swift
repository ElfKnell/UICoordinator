//
//  MapVisionSheetConfig.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/08/2025.
//

import Foundation

enum MapVisionSheetConfig: Int, Identifiable {
    
    case locationDetails
    case routeDetails
    
    var id: Int {
        self.rawValue
    }
}
