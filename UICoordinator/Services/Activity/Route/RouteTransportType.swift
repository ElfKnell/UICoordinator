//
//  RouteTransportType.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation
import MapKit

enum RouteTransportType: String, Codable, CaseIterable, Identifiable {
    
    case automobile
    case walking
    case any
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .automobile: return "Automobile"
        case .walking: return "Walking"
        case .any: return "Any"
        }
    }
    
    var mkTransportType: MKDirectionsTransportType {
        switch self {
        case .automobile: return .automobile
        case .walking: return .walking
        case .any: return .any
        }
    }
}

extension RouteTransportType {
    
    init(mkTransportType: MKDirectionsTransportType) {
        
        switch mkTransportType {
        case .automobile:
            self = .automobile
        case .walking:
            self = .walking
        case .any:
            self = .any
        default:
            self = .any
        }
    }
}
