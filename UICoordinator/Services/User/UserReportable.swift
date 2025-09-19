//
//  UserReportable.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/09/2025.
//

import Foundation

extension User: ReportableProtocol {
    
    var reportDescription: String {
        """
        User id: \(id)
        \(username)
        """
    }
    
}
