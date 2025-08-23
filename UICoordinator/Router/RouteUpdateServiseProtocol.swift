//
//  RouteUpdateServiseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import Foundation
import MapKit

protocol RouteUpdateServiseProtocol {
    
    func updateRoute(_ route: RoutePair) async throws
    
}
