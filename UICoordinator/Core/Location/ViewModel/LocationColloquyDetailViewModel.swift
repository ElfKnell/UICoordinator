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
    
    //let videoService: VideoServiceProtocol
    let photoService: PhotoServiceProtocol
    
    init(photoService: PhotoServiceProtocol) {
        
        //self.videoService = videoService
        self.photoService = photoService
    }
    
    @MainActor
    func fetchPhoto(_ locationId: String) async {
        do {
            self.photos = try await photoService
                .fetchPhotosByLocation(locationId)
            
            if !self.photos.isEmpty {
                self.switcher = .newPhoto
            } else {
                self.switcher = .noPhoto
            }
        } catch {
            print("ERROR FETCHING PHOTO: \(error.localizedDescription)")
        }
    }
    
//    @MainActor
//    func fetchVideos(_ locationId: String) async {
//        do {
//            self.videos = try await videoService
//                .fetchVideosByLocation(locationId)
//        } catch {
//            print("ERROR FETCHING VIDEO: \(error.localizedDescription)")
//        }
//    }
}
