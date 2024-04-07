//
//  CurrentUserProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    @State private var showEditProfile = false
    
    private var currentUser: User {
        return viewModel.currentUser ?? DeveloperPreview.user
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                ProfileHeaderView(user: currentUser)
                
                Button {
                    showEditProfile.toggle()
                } label: {
                    Text("Edit profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(width: 352, height: 32)
                        .background(.white)
                        .modifier(CornerRadiusModifier())
                }
                
                if let user = viewModel.currentUser {
                    UserContentListView(user: user)
                }
            }
        }
        .sheet(isPresented: $showEditProfile, content: {
            EditProfileView(user: currentUser)
        })
    }
}

#Preview {
    CurrentUserProfileView()
}
