//
//  AboutView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 30/03/2024.
//

import SwiftUI

struct AboutView: View {
    
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    
    private var currentUser: User {
        return viewModel.currentUser ?? DeveloperPreview.user
    }
    
    var body: some View {
        ScrollView {
            if let user = viewModel.currentUser {
                UserContentListView(user: user)
            }
        }
    }
}

#Preview {
    AboutView()
}
