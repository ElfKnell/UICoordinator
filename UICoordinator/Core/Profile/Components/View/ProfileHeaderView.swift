//
//  ProfileHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading) {
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user.username)
                        .font(.subheadline)
                }
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                }
                
                Text("2 followers")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            CircularProfileImageView(user: user, size: .medium)
        }
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.user)
}
