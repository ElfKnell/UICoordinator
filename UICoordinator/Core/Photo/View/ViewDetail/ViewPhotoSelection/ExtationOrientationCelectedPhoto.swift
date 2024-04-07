//
//  ExtationOrientationCelectedPhoto.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/03/2024.
//

import SwiftUI

extension OrientationPhotoSelectedView {
    
    var HHeaderPhotoSelected: some View {
        HStack {
            ImageView(photoURL: viewModel.photo?.photoURL)
            
            TextField("Photo name ...", text: $viewModel.namePhoto)
                .frame(width: 300)
        }
    }
    
    var VHeaderPhotoSelected: some View {
        VStack {
            ImageView(photoURL: viewModel.photo?.photoURL)
            
            TextField("Photo name ...", text: $viewModel.namePhoto)
                .frame(width: 300)
                .padding(.bottom)
        }
    }
    
    var BodyPhotoSelected: some View {
        Group {
            
            HStack {
                Button {
                    viewModel.namePhoto = ""
                } label: {
                     LabelButtonView(imageName: "eraser.line.dashed.fill", label: "Clean")
                }
                .padding(.horizontal)
                
                Button {
                    viewModel.clean()
                } label: {
                    LabelButtonView(imageName: "xmark.circle.fill", label: "Cancel")
                }
            }
            .padding()
            
            HStack {
                Button {
                    Task {
                        try await viewModel.deletePhoto()
                    }
                } label: {
                    LabelButtonView(imageName: "trash.circle.fill", label: "Delete")
                }
                .padding(.horizontal)
                
                Button {
                    Task {
                        try await viewModel.updatePhotoName()
                    }
                } label: {
                     LabelButtonView(imageName: "square.and.arrow.up.circle.fill", label: "Update")
                }
            }
        }
    }
}
