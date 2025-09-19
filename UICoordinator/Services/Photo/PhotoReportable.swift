//
//  PhotoReportable.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import Foundation

extension Photo: ReportableProtocol {
    
    var reportDescription: String {
        """
        Photo id: \(id)
        \(photoURL)
        \(name ?? "none")
        """
    }
    
}
