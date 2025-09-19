//
//  ActivityReportable.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import Foundation

extension Activity: ReportableProtocol {
    
    var reportDescription: String {
        """
        Activity id: \(id)
        \(name)
        """
    }
    
}
