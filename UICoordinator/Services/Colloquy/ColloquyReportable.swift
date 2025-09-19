//
//  ColloquyReportable.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import Foundation

extension Colloquy: ReportableProtocol {
    
    var reportDescription: String {
        """
        Colloquy id: \(id)
        \(caption)
        """
    }
    
}
