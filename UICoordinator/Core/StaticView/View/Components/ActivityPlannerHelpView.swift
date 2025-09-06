//
//  ActivityPlannerHelpView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct ActivityPlannerHelpView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("🗺️ Activity Planning and Sharing")
                .font(.title2)
                .bold()
                    
            Text("""
        This is one of the **core features** of the app.

        You can **create your own travel routes** by adding markers for places you'd like to visit. You can:

        • **Plot routes** between locations  
        • **Change route types** (e.g. walking, driving)  
        • **Switch map styles** (standard, satellite, hybrid)  
        • **Add descriptions** to your routes or to others’  
        • **Share routes** with friends and fellow users

        This helps you organize your travels and discover new places shared by the community.
        """)
            
        }
        .padding()
    }
}

#Preview {
    ActivityPlannerHelpView()
}
