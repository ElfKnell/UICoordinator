//
//  PhotoVideoLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import SwiftUI

struct PhotoVideoLocationView: View {
    let locationId: String
    
    var body: some View {
        Section {
            VStack {
                
                NavigationLink(destination: PhotoView(locationId: locationId)) {
                    Text("Choose Photo")
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
            
            VStack {
                NavigationLink(destination: VideoView(locationId: locationId)) {
                    Text("Choose Video")
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
    }
}

#Preview {
    PhotoVideoLocationView(locationId: "")
}
