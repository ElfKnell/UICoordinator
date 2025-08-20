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
    case transit
    case bicycle
    case any
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .automobile: return "Automobile"
        case .walking: return "Walking"
        case .transit: return "Transit"
        case .bicycle: return "Bicycle"
        case .any: return "Any"
        }
    }
    
    var mkTransportType: MKDirectionsTransportType {
        switch self {
        case .automobile: return .automobile
        case .walking: return .walking
        case .transit: return .transit
        case .bicycle:
            if #available(iOS 14.0, *) {
                return .walking
            } else {
                return .any
            }
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
        case .transit:
            self = .transit
        case .any:
            self = .any
        default:
            self = .any
        }
    }
}
