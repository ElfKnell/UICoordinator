//
//  RoutePair.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import MapKit

struct RoutePair: Identifiable, Hashable, Equatable {
    
    var storedRoute: StoredRoute
    var mkRoute: MKRoute
    
    var id: String { storedRoute.id }
    
    static func == (lhs: RoutePair, rhs: RoutePair) -> Bool {
        lhs.id == rhs.id
    }
}
