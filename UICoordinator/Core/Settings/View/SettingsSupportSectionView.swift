//
//  SettingsSupportSectionView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/08/2025.
//

import SwiftUI
import MessageUI

struct SettingsSupportSectionView: View {
    
    @State private var showMailErrorAlert = false
    @StateObject private var viewModel = SettingsSupportSectionViewModel()
    
    var body: some View {
        
        Section(header: Text("Support")) {
            
            if let url = viewModel.shareAppURL {
                
                ShareLink(item: url) {
                    
                    Label("Recommend Trailcraft",
                          systemImage: "square.and.arrow.up")
                    
                }
                
            }
            
            Button {
                viewModel.rateApp()
            } label: {
                Label("Rate Trailcraft", systemImage: "star.fill")
            }
            
            Button {
                
                if MFMailComposeViewController.canSendMail() {
                    viewModel.sendFeedbackEmail()
                } else {
                    showMailErrorAlert = true
                }
                
            } label: {
                Label("Send Feedback via Email",
                      systemImage: "envelope.fill")
            }
            
        }
        .alert("Email not configured", isPresented: $showMailErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please set up a Mail account in order to send feedback.")
        }
    }
}

#Preview {
    SettingsSupportSectionView()
}
