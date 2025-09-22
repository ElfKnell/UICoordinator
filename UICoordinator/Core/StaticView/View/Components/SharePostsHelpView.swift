//
//  SharePostsHelpView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct SharePostsHelpView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("📤 Sharing Posts with Other Users")
                .font(.title2)
                .bold()
                    
            Text("""
            In the next section of the app, you can **share posts** that other users can see and use.
            
            Each post may include:
            • A marker with a specific location  
            • A title and description
            • Photos 
            
            Shared posts can be **opened in map, updated, and reused** by other users.  
            This helps build a community-based library of useful locations and recommendations.
            """)
            
        }
        .padding()
    }
}

#Preview {
    SharePostsHelpView()
}
