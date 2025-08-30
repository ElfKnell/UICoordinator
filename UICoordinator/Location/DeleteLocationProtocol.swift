//
//  DeleteLocationProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import Foundation

protocol DeleteLocationProtocol {
    
    func deleteLocation(at locationId: String) async throws
    
    func deleteLocations(with locationsId: [String]) async throws
    
}
