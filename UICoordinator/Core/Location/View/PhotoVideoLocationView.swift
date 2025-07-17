//
//  PhotoVideoLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import SwiftUI

struct PhotoVideoLocationView: View {
    
    let location: MapSelectionProtocol
    @EnvironmentObject var conteiner: DIContainer
    
    @StateObject var viewModelPhoto: PhotoViewModel
    @StateObject var viewModelVideo: VideoViewModel
    
    @MainActor
    init(location: MapSelectionProtocol,
         viewModelPhotoBilder: @MainActor @escaping () -> PhotoViewModel = {
        PhotoViewModelFactory.make()
    }, viewModelVideoBilder: @MainActor @escaping () -> VideoViewModel = {
        VideoViewModelFactory.make()
    }) {
        self.location = location
        _viewModelPhoto = StateObject(wrappedValue: viewModelPhotoBilder())
        _viewModelVideo = StateObject(wrappedValue: viewModelVideoBilder())
    }
    
    var body: some View {
        Group {
            VStack {
                
                if CheckingForCurrentUser.isOwnerCurrentUser(location.ownerUid, currentUser: conteiner.currentUserService.currentUser) {
                    
                    NavigationLink {
                        PhotosWithChangingView(locationId: location.id)
                            .environmentObject(viewModelPhoto)
                        
                    } label: {
                        Text("Choose Photo")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    
                } else {
                    
                    NavigationLink {
                        LocationPhotosView(activity: location)
                            .environmentObject(viewModelPhoto)
                        
                    } label: {
                        Text("Choose Photo")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    
                }
            }
            
            VStack {
                NavigationLink {
                    VideoView(
                        locationId: location.id,
                        isAccessible: CheckingForCurrentUser.isOwnerCurrentUser(location.ownerUid, currentUser: conteiner.currentUserService.currentUser))
                        .environmentObject(viewModelVideo)
                } label: {
                    Text("Choose Video")
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
    }
}

#Preview {
    PhotoVideoLocationView(location: DeveloperPreview.location)
}
