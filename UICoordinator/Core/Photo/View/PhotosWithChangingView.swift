//
//  PhotoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotosWithChangingView: View {
    
    let locationId: String
    @StateObject var viewModel = PhotoViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    
                    if !viewModel.photos.isEmpty {
                        PhotoScrollView(photos: viewModel.photos, bphoto: $viewModel.photo, switcher: $viewModel.switcher, namePhoto: $viewModel.namePhoto)
                    }
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        
                        LoadingView(width: 130, height: 130)
                        
                        Spacer()
                        
                    } else {
                        
                        switch viewModel.switcher {
                        case .newPhoto:
                            NewPhotoView(locationId: locationId)
                                .environmentObject(viewModel)
                            
                        case .oldPhoto:
                            
                            OrientationPhotoSelectedView()
                                .environmentObject(viewModel)
                            
                        case .noPhoto:
                            SelectionPhotoView()
                                .environmentObject(viewModel)
                        }
                    }
                }
                .navigationTitle("Photos")
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await viewModel.fetchPhoto(locationId)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        BackButtonView()
                    }
                }
            }
        }
    }
}

#Preview {
    PhotosWithChangingView(locationId: "")
}
