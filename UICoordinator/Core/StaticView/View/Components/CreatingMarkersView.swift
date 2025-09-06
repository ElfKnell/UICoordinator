//
//  CreatingMarkersView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/09/2025.
//

import SwiftUI

struct CreateMarkerHelpView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("📍 Creating and Managing Markers")
                .font(.title2)
                .fontWeight(.bold)

            Group {
                Text("On the main screen of the app, you can create custom markers. Each marker can include:")
                            
                Text("• A name and description") +
                Text(" to identify the location.")
                            
                Text("• Nearby places: ").bold() +
                Text("Tap the ") +
                Text("Details").italic() +
                Text(" button to explore interesting spots near the selected location.")
                            
                Text("• Media attachments: ").bold() +
                Text("Add ") +
                Text("photos and videos").italic() +
                Text(" to your markers to capture visual details.")
                            
                Text("• Sharing: ").bold() +
                Text("Share your markers with other users, including descriptions and media.")
            }
            .font(.body)

                Text("This feature helps you personalize your map and easily manage meaningful places.")
                    .font(.body)
                    .padding(.top, 8)
        }
        .padding()
        
    }
}

#Preview {
    CreateMarkerHelpView()
}
