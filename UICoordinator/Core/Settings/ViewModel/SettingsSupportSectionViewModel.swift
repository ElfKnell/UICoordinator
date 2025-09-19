//
//  SettingsSupportSectionViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/08/2025.
//

import Foundation
import StoreKit

class SettingsSupportSectionViewModel: ObservableObject {
    
    @Published var showMailErrorAlert = false
    
    private let appID = "6748606035"
    
    private let supportEmail = "kyrych.app@gmail.com"
    
    private let emailSender: EmailSenderProtocol
    
    var shareAppURL: URL? {
        URL(string: "https://apps.apple.com/app/id\(appID)")
    }
    
    init(emailSender: EmailSenderProtocol) {
        self.emailSender = emailSender
    }
    
    @MainActor
    func rateApp() {
        if let scene = UIApplication.shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            if #available(iOS 18, *) {
                AppStore.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    func sendFeedbackEmail() {
        
        let subject = "Feedback for Trailcraft App"
        let body = "Hello, I’d like to share feedback..."
        
        emailSender.sendFeedbackEmail(subject: subject, body: body)
    }
    
}
