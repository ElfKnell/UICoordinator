//
//  VideoReportable.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import Foundation

extension Video: ReportableProtocol {
    
    var reportDescription: String {
        """
        Video id: \(id)
        \(videoURL)
        \(title ?? "none")
        """
    }
    
}
