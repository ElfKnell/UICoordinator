//
//  CreateRouterProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/06/2025.
//

import Foundation
import MapKit

protocol CreateRouterProtocol {
    
    func uploadRoute(_ route: StoredRoute) async throws
    
}
