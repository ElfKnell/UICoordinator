//
//  LocationColloqueDetalView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/04/2024.
//

import SwiftUI

struct LocationPhotosView: View {
    
    let activity: MapSelectionProtocol
    @StateObject var viewModel: LocationColloquyDetailViewModel
    
    init(activity: MapSelectionProtocol,
         viewModelBilder: @escaping () -> LocationColloquyDetailViewModel = {
        LocationColloquyDetailViewModel(
            //videoService: VideoService(),
            photoService: PhotoService())
    }) {
        self.activity = activity
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        ZStack {
            
            BackgroundView()
            
            VStack {
                
                if !viewModel.photos.isEmpty {
                    PhotoScrollView(photos: viewModel.photos, bphoto: $viewModel.photo, switcher: $viewModel.switcher, namePhoto: $viewModel.namePhoto)
                }
                
                VStack {
                    
                    switch viewModel.switcher {
                    case .oldPhoto:
                        VStack {
                            
                            if let photo = viewModel.photo {
                                PhotoView(photo: photo)
                            }
                            
                        }
                    case .newPhoto:
                        VStack {
                            if let firstPhoto = viewModel.photos.first {
                                PhotoView(photo: firstPhoto)
                            }
                        }
                    case .noPhoto:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue)
                            .padding()
                    }
                    
                }
                .padding(.top)
            }
        }
        .navigationTitle(activity.name)
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.fetchPhoto(activity.id)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
        }
    }
}

#Preview {
    LocationPhotosView(activity: DeveloperPreview.location)
}
