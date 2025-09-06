//
//  ProfileSettingsHelpView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct ProfileSettingsHelpView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("👤 Profile Settings and Management")
                .font(.title2)
                .bold()
                    
            Text("""
        In this section, you can **customize your user profile** and manage your activity:

        • **Edit personal information** (e.g. name, bio)  
        • **View your own posts** and shared content  
        • **Delete unwanted posts**  
        • Stay in control of what other users see on your profile

        Use this section to keep your profile up-to-date and manage your shared content easily.
        """)
            
        }
        .padding()
    }
}

#Preview {
    ProfileSettingsHelpView()
}
