//
//  LocationColloqueDetalView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/04/2024.
//

import SwiftUI

struct LocationPhotosView: View {
    
    let activity: MapSelectionProtocol
    @StateObject var viewModel = LocationColloquyDetailViewModel()
    
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
                            ImageView(photoURL: viewModel.photo?.photoURL)
                            
                            Text(viewModel.namePhoto)
                                .padding(.bottom)
                        }
                    case .newPhoto:
                        VStack {
                            ImageView(photoURL: viewModel.photos[0].photoURL)
                            
                            Text(viewModel.photos[0].name ?? "")
                                .padding(.bottom)
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
        .onAppear {
            Task {
                try await viewModel.fetchPhoto(activity.id)
            }
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
