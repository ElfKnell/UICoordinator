//
//  SideMenuHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    private var user: User {
        return viewModel.currentUser ?? DeveloperPreview.user
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .medium)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.username)
                    .font(.subheadline)
                
                Text(user.email)
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
