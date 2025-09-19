//
//  ReportButtonViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2025.
//

import Foundation

class ReportButtonViewModel: ObservableObject {
    
    private let emailSender: EmailSenderProtocol
    
    init(emailSender: EmailSenderProtocol) {
        self.emailSender = emailSender
    }
    
    func sendReport(_ object: ReportableProtocol) {
        
        let subject = "Complaint from a Trailcraft user"
        let body = """
            Please describe your complaint below:


            ---
            \(object.reportDescription)
            """
        
        emailSender.sendFeedbackEmail(subject: subject, body: body)
    }

}
