//
//  SelectedPhotoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/03/2024.
//

import SwiftUI
import Kingfisher

struct SelectedPhotoView: View {
    let photoURL: String
    
    var body: some View {
            
        GeometryReader { proxy in
            KFImage(URL(string: photoURL))
                .resizable()
                .scaledToFit()
                .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
        }
    }
}

#Preview {
    SelectedPhotoView(photoURL: "")
}
