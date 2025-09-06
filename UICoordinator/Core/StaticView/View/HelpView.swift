//
//  HelpView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 24) {
                
                CreateMarkerHelpView()
                SharePostsHelpView()
                UserSearchHelpView()
                ActivityPlannerHelpView()
                ProfileSettingsHelpView()
                
            }
            .padding()
            
        }
        .navigationTitle("Help")
    }
}

#Preview {
    HelpView()
}
