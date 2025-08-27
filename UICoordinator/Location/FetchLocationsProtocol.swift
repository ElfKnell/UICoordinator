//
//  UserLocationsProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/04/2025.
//

import Foundation

protocol FetchLocationsProtocol {
    
    func getLocations(userId: String, pageSize: Int) async -> [Location]
    
    func reload()
    
}
