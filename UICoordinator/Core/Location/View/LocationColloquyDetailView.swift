//
//  LocationColloqueDetalView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/04/2024.
//

import SwiftUI

struct LocationColloquyDetailView: View {
    let location: Location
    @StateObject var viewModel = LocationColloquyDetailViewModel()
    @State private var showVideo = false
    
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
                    
                    
                    HStack {
                        Text("Description: ")
                        
                        Text(location.description)
                    }
                    .padding(.bottom)
                }
                .padding(.top)
            }
        }
        .navigationTitle(location.name)
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                try await viewModel.fetchPhoto(location.id)
                try await viewModel.fetchVideos(location.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showVideo.toggle()
                } label: {
                    Image(systemName: "play.circle")
                }
            }
        }
        .fullScreenCover(isPresented: $showVideo) {
            LocationVideoView(videos: viewModel.videos)
        }
    }
}

#Preview {
    LocationColloquyDetailView(location: DeveloperPreview.location)
}
