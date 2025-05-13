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
    let verificationOwner = CheckingForCurrentUser()
    
    var body: some View {
        Group {
            VStack {
                
                if verificationOwner.isOwnerCurrentUser(location.ownerUid, currentUser: conteiner.currentUserService.currentUser) {
                    
                    NavigationLink(destination: PhotosWithChangingView(locationId: location.id)) {
                        Text("Choose Photo")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    
                } else {
                    
                    NavigationLink(destination: LocationPhotosView(activity: location)) {
                        Text("Choose Photo")
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()
                    
                }
            }
            
            VStack {
                NavigationLink(destination: VideoView(locationId: location.id, isAccessible: verificationOwner.isOwnerCurrentUser(location.ownerUid, currentUser: conteiner.currentUserService.currentUser))) {
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
