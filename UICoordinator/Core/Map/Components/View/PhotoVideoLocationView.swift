//
//  PhotoVideoLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import SwiftUI

struct PhotoVideoLocationView: View {
    var body: some View {
        Section {
            VStack {
                
                NavigationLink(destination: FeedView()) {
                    Text("Choose Photo")
                }
                .padding()
                
                NavigationLink(destination: FeedView()) {
                    Text("Choose Video")
                }
                .padding()
            }
        }
    }
}

#Preview {
    PhotoVideoLocationView()
}
