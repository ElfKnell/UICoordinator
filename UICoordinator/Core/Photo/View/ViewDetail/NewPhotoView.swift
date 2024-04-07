//
//  NewPhotoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/03/2024.
//

import SwiftUI

struct NewPhotoView: View {
    let locationId: String
    @EnvironmentObject var viewModel: PhotoViewModel
    
    var body: some View {
        VStack {
            ImageView(image: viewModel.selectedImage)
            
            TextField("Photo name ...", text: $viewModel.namePhoto)
                .frame(width: 300)
                .padding(.bottom)
            
            HStack {
                
                Button {
                    viewModel.clean()
                } label: {
                    LabelButtonView(imageName: "xmark.circle.fill", label: "Cancel")
                }
                .padding()
                
                Button {
                    Task {
                        try await viewModel.uploadPhoto(locationId: locationId)
                    }
                } label: {
                    LabelButtonView(imageName: "square.and.arrow.up.fill", label: "Save")
                }
                .padding()
                .opacity(viewModel.namePhoto.isEmpty ? 0.3 : 1.0)
                .disabled(viewModel.namePhoto.isEmpty)

            }
            
        }
    }
}

#Preview {
    NewPhotoView(locationId: "")
}
