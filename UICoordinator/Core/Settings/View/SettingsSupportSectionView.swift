//
//  SettingsSupportSectionView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/08/2025.
//

import SwiftUI
import MessageUI

struct SettingsSupportSectionView: View {
    
    @StateObject private var viewModel : SettingsSupportSectionViewModel
    
    init(viewModelBilder: @escaping () -> SettingsSupportSectionViewModel = {
        SettingsSupportSectionViewModel(
            emailSender: EmailSender()
        )
    }) {
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
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
                    viewModel.showMailErrorAlert = true
                }
                
            } label: {
                Label("Send Feedback via Email",
                      systemImage: "envelope.fill")
            }
            
        }
        .alert("Email not configured", isPresented: $viewModel.showMailErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please set up a Mail account in order to send feedback.")
        }
    }
}

#Preview {
    SettingsSupportSectionView()
}
