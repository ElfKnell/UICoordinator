//
//  VideoViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/03/2024.
//

import Firebase
import PhotosUI
import SwiftUI

class VideoViewModel: ObservableObject {
    
    @Published var isLoaded = true
    @Published var locationVideo = [Video]()
    @Published var locationId: String?
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await uploadVideo() }}
    }
    
    @MainActor
    func uploadVideo() async throws {
        isLoaded = false
        
        do {
            guard let lId = locationId else { return }
            guard let item = selectedItem else { return }
            guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
            guard let videoURL = await VideoService.uploadVideoStorage(withData: videoData, locationId: lId) else { return }
            let video = Video(locationUid: lId, timestamp: Timestamp(), videoURL: videoURL)
            try await VideoService.uploadVideo(video)
            
            isLoaded = true
        } catch {
            print("DEBUG: ERROR: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchVideoByLocation() async throws {
        guard let lId = self.locationId else { return }
        self.locationVideo = try await VideoService.fetchVideosByLocation(lId)
    }
    
    @MainActor
    func uploadTitle(vId: String, title: String) async throws {
        try await VideoService.updatTitle(vId: vId, title: title)
    }
    
    @MainActor
    func deleteVideo(_ videoId: String) async throws{
        await VideoService.deleteVideo(videoId: videoId)
        try await fetchVideoByLocation()
    }
}
