//
//  ErrorActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation

enum ErrorActivity: Error, LocalizedError {
    
    case locationNotFound
    case routeNotFound
    case encodingFailed
    case encodingFailedRoute
    
    var description: String {
        switch self {
        case .locationNotFound:
            return "Current location not found"
        case .routeNotFound:
            return "Failed to generate the route."
        case .encodingFailedRoute:
            return "Failed to encode Route object"
        case .encodingFailed:
            return "Failed to encode Activity object"
        }
    }
}
