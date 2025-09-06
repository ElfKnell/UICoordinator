//
//  UserSearchHelpView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct UserSearchHelpView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("👥 Searching and Following Users")
                .font(.title2)
                .bold()
                    
            Text("""
        In this section, you can **search for other users** and **follow** them to stay updated with their activity.

        By tapping on a user's name, you can **view the markers** they’ve created and shared on the map.

        This feature allows you to explore locations discovered by the community and connect with like-minded travelers or explorers.
        """)
            
        }
        .padding()
    }
}

#Preview {
    UserSearchHelpView()
}
