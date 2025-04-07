//
//  AboutView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 30/03/2024.
//

import SwiftUI

struct AboutView: View {
    
    @StateObject var viewModel = AboutViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.info_1)
            Text(viewModel.info_2)
        }
        .padding()
        .navigationTitle("About Us")
    }
}

#Preview {
    AboutView()
}
