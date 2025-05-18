//
//  NetworkMonitor.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/05/2025.
//

import Observation
import Network
import Foundation

@Observable
class NetworkMonitor: ReachabilityProtocol {
    
    var isConnected = false
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    
    init() {
        
        monitor = NWPathMonitor()
        queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: self.queue)
    }

}
