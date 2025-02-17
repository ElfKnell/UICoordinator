//
//  UserCellView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2024.
//

import SwiftUI

struct UserCellView: View {
    let user: User
    @EnvironmentObject var userFollow: UserFollowers
    
    var body: some View {
        HStack {
            
            CircularProfileImageView(user: user, size: .small)
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text(user.username)
                    .fontWeight(.semibold)
                
                Text(user.fullname)
                
            }
            .font(.footnote)
            
            Spacer()
            
            Text(userFollow.checkFollow(uid: user.id) ? "Unfollow" : "Follow")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 100, height: 32)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }

        }
        .padding(.horizontal)
    }
}

#Preview {
    UserCellView(user: DeveloperPreview.user)
}
