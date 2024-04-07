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
        VStack(spacing: 16) {
            
            VStack {
                
                CircularProfileImageView(user: user, size: .large)
                
                Group {
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("djufidfidn  ndsinsdivnjdis sjdckjdsn")
                    
                    if let bio = user.bio {
                        Text(bio)
                            .font(.footnote)
                    }
                }
                
                Divider()
                
                HStack(spacing: 16) {
                    
                    BottomHeaderView(title: "Following", counts: "4", imageName: "person.3.fill")
                    
                    BottomHeaderView(title: "Followers", counts: "45", imageName: "person.crop.circle.fill.badge.checkmark")
                    
                    BottomHeaderView(title: "Likes", counts: "2345", imageName: "heart.fill")
                }
            }
        }
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.user)
}
