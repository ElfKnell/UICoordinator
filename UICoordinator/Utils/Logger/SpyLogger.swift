//
//  SpyLogger.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation

class SpyLogger: LoggerProtocol {
    
    var messages: [String] = []
    
    func log(_ message: String) {
        messages.append(message)
    }

}
