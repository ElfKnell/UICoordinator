//
//  NetworkMonitor.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/05/2025.
//

import Network
import Foundation

class NetworkMonitor: ReachabilityProtocol {
    
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    
    private var networkStatusContinuation: AsyncStream<Bool>.Continuation?
    private var wentOfflineContinuation: AsyncStream<Void>.Continuation?
    
    private var _currentStatus: Bool = false
    var isConnected: Bool {
        return _currentStatus
    }
    
    lazy var networkStatusUpdates: AsyncStream<Bool> = {
        return AsyncStream { continuation in
            self.networkStatusContinuation = continuation
            self.setupMonitor()
        }
    }()
    
    lazy var wentOfflineUpdates: AsyncStream<Void> = {
        AsyncStream { continuation in
            self.wentOfflineContinuation = continuation
            self.setupMonitor()
        }
    }()
    
    init() {
        
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "com.trailcraft.NetworkMonitorQueue.AsyncAwait", qos: .background)
        
    }
    
    private func setupMonitor() {
        
        guard monitor.pathUpdateHandler == nil else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let newStatus = path.status == .satisfied
            
            DispatchQueue.main.async {
                self._currentStatus = newStatus
                self.networkStatusContinuation?.yield(newStatus)
                if !newStatus {
                    self.wentOfflineContinuation?.yield(())
                }
            }
        }
        monitor.start(queue: self.queue)
        
        self.networkStatusContinuation?.onTermination = { [weak self] _ in
            self?.handleStreamTermination()
        }
        self.wentOfflineContinuation?.onTermination = { [weak self] _ in
            self?.handleStreamTermination()
        }
    }

    func handleStreamTermination() {
        self.monitor.cancel()
    }
    
    deinit {
        monitor.cancel()
    }
}
