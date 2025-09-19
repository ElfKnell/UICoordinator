//
//  PhotoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import SwiftUI

struct PhotoView: View {
    
    var photo: Photo
    
    var body: some View {
        
        VStack {
            
            KingfisherPhoto(photoURL: photo.photoURL)
            
            Text(photo.name ?? "no name")
                .padding()
            
            HStack {
                
                Spacer()
                
                ReportButtonView(object: photo)
                
            }
        }
        .padding()
    }
}

#Preview {
    PhotoView(photo: DeveloperPreview.photo)
}
