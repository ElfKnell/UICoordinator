//
//  SideMenuHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuHeaderView: View {
    
    var user: User?
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: user, size: .medium)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user?.username ?? "")
                    .font(.subheadline)
                
                Text(user?.email ?? "")
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}

#Preview {
    SideMenuHeaderView(user: DeveloperPreview.user)
}
