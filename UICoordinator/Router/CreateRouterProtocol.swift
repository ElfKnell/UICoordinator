//
//  CreateRouterProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/06/2025.
//

import Foundation
import MapKit

protocol CreateRouterProtocol {
    func getRouter(coordinate: CLLocationCoordinate2D?,
                   mapSelection: Location?) async throws -> MKRoute?
}
