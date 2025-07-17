//
//  AppConnectivityManager.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/07/2025.
//

import Foundation
import Observation
import Network

@Observable
@MainActor
class AppConnectivityManager {
    
    var isDisconected = false
    private let networkMonitor: ReachabilityProtocol
    private var networkObservationTask: Task<Void, Never>?
    
    init(networkMonitor: ReachabilityProtocol, networkObservationTask: Task<Void, Never>? = nil) {
        self.networkMonitor = networkMonitor
        self.networkObservationTask = networkObservationTask
    }
    
    func startMonitoringForOffline() {
        networkObservationTask?.cancel()
        
        networkObservationTask = Task {
            for await _ in networkMonitor.wentOfflineUpdates {
                isDisconected = true
            }
        }
    }
    
    func stopMonitoringForOffline() {
        networkObservationTask?.cancel()
        networkObservationTask = nil
        isDisconected = false
    }
}
