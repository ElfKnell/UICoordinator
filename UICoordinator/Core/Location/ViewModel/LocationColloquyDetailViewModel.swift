//
//  LocationColloquyDetailViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/04/2024.
//

import Foundation

class LocationColloquyDetailViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var photo: Photo?
    @Published var namePhoto = ""
    @Published var switcher = PhotoSwitch.noPhoto
    @Published var videos = [Video]()
    
    @MainActor
    func fetchPhoto(_ locationId: String) async throws {
        self.photos = try await PhotoService.fetchPhotoByLocation(locationId)
        
        if !self.photos.isEmpty {
            self.switcher = .newPhoto
        } else {
            self.switcher = .noPhoto
        }
    }
    
    @MainActor
    func fetchVideos(_ locationId: String) async throws {
        self.videos = try await VideoService.fetchVideoByLocation(locationId)
    }
}
