//
//  EmailSender.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2025.
//

import Foundation
import UIKit
import MessageUI

class EmailSender: NSObject, EmailSenderProtocol, MFMailComposeViewControllerDelegate {
    
    private let supportEmail = "kyrych.app@gmail.com"
    
    func sendFeedbackEmail(subject: String, body: String) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([supportEmail])
            mailVC.setSubject(subject)
            mailVC.setMessageBody(body, isHTML: false)
            
            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })?
                .windows.first?.rootViewController {
                            
                rootVC.present(mailVC, animated: true)
            }
            
        } else {
            
            openMailFallback(subject: subject, body: body)
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func openMailFallback(subject: String, body: String) {
        
        let encodedSubject = subject.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        let encodedBody = body.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        
        if let url = URL(
            string: "mailto:\(supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)"
        ) {
            UIApplication.shared.open(url)
        }
    }
    
}
