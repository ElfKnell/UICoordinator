//
//  ReachabilityProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/05/2025.
//

import Foundation

protocol ReachabilityProtocol {
    
    var isConnected: Bool { get }
    var networkStatusUpdates: AsyncStream<Bool> { get }
    var wentOfflineUpdates: AsyncStream<Void> { get }
    
}
