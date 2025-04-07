//
//  UpdateLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import Foundation

protocol UpdateLocationProtocol {
    
    func updateNameAndDescriptionLocation(name: String, description: String, locationId: String) async
    
    func updateAddressLocation(address: String, locationId: String) async
}
