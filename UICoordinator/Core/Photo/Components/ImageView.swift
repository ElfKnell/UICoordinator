//
//  ImageView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/03/2024.
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    
    var image: UIImage?
    var photoURL: String?
    
    var body: some View {
        
        if let image = image {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .modifier(CornerRadiusModifier())
                .padding()
            
        } else if let photoURL = photoURL {
            
            NavigationLink {
                SelectedPhotoView(photoURL: photoURL)
            } label: {
                KFImage(URL(string: photoURL))
                    .resizable()
                    .scaledToFit()
                    .modifier(CornerRadiusModifier())
                    .padding()
            }
        }
    }
}

#Preview {
    ImageView()
}
