//
//  ProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 20) {
                
                ProfileHeaderView(user: user)
                
                Button {
                    
                } label: {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 352, height: 32)
                        .background(.black)
                        .cornerRadius(8)
                }
                
                UserContentListView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
