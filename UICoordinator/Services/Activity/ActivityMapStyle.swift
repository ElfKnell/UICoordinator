//
//  ActivityMapStyle.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/03/2025.
//

import Foundation
import SwiftUI
import MapKit

enum ActivityMapStyle: Int, Codable, CaseIterable, Identifiable {
    case standard
    case hybrid
    case imagery
    
    var description: String {
        switch self {
        case .standard:
            return "Standard"
        case .hybrid:
            return "Hybrid"
        case .imagery:
            return "Imagery"
        }
    }
    
    var value: MapStyle {
        switch self {
        case .standard:
            return .standard(elevation: .realistic)
        case .hybrid:
            return .hybrid(elevation: .realistic)
        case .imagery:
            return .imagery(elevation: .realistic)
        }
    }
    
    var id: Int { return self.rawValue }
}
