//
//  EmailSenderProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2025.
//

import Foundation

protocol EmailSenderProtocol {
    
    func sendFeedbackEmail(subject: String, body: String)
    
}
