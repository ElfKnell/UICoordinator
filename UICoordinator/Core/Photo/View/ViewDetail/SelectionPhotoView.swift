//
//  SelectionPhotoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/03/2024.
//

import SwiftUI
import PhotosUI

struct SelectionPhotoView: View {
    @EnvironmentObject var viewModel: PhotoViewModel
    @State private var showCamera = false
    
    var body: some View {
        
        VStack {
            PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.images, .not(.videos)])) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.blue)
                    .padding()
            }
            
            Spacer()
            
            HStack {
                
                Button {
                    showCamera.toggle()
                } label: {
                    LabelButtonView(imageName: "camera.circle.fill", label: "Camera")
                }
                .padding(.horizontal)
                
                PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.images, .not(.videos)])) {
                    LabelButtonView(imageName: "photo", label: "Photo")
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showCamera, content: {
            ImagePicker(image: $viewModel.selectedImage, sourceType: .camera, swicher: $viewModel.switcher)
        })
    }
}

#Preview {
    SelectionPhotoView()
}
