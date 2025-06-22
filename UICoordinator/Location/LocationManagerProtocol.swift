//
//  LocationManagerProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/06/2025.
//

import Foundation

protocol LocationManagerProtocol {
    
    var isTrackingAvailable: Bool { get }
    func checkAndRequestPermission() async
    
}
