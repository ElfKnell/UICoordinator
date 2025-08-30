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
    case noMatchingStoredRoute
    case failedBuildRoute
    case failedUpdateRoute
    case idNotFound
    case nameNil
    
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "Current location not found"
        case .routeNotFound:
            return "Failed to generate the route"
        case .encodingFailedRoute:
            return "Failed to encode Route object"
        case .encodingFailed:
            return "Failed to encode Activity object"
        case .noMatchingStoredRoute:
            return "No matching stored route found"
        case .failedBuildRoute:
            return "Failed to build updated route"
        case .failedUpdateRoute:
            return "Could not update route"
        case .idNotFound:
            return "Current id not found"
        case .nameNil:
            return "The name field cannot be empty"
        }
    }
}
