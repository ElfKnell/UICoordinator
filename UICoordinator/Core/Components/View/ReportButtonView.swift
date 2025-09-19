//
//  ReportButtonView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2025.
//

import SwiftUI

struct ReportButtonView: View {
    
    let object: ReportableProtocol
    @StateObject private var viewModel: ReportButtonViewModel
    
    init(object: ReportableProtocol,
         viewModelBilder: @escaping () -> ReportButtonViewModel = {
        ReportButtonViewModel(emailSender: EmailSender())
    }) {
        
        self.object = object
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        Button {
            viewModel.sendReport(object)
        } label: {
            Label("Report", systemImage: "exclamationmark.bubble")
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 2)
        )
        
    }
}

#Preview {
    ReportButtonView(object: MockObjectReportable())
}
