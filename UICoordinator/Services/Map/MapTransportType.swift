//
//  MapTransportType.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/03/2025.
//

import Foundation
import SwiftUI
import MapKit

enum MapTransportType: Int, Codable, CaseIterable, Identifiable {
    case automobile
    case walking
    
    var description: String {
        switch self {
        case .automobile:
            return "Automobile"
        case .walking:
            return "Walking"
        }
    }
    
    var value: MKDirectionsTransportType {
        switch self {
        case .automobile:
            return .automobile
        case .walking:
            return .walking
        }
    }
    
    var id: Int { return self.rawValue }
}
