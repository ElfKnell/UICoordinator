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
        didSet { Task { await uploadVideo() }}
    }
    private let videoService: VideoServiceProtocol
    
    init(videoService: VideoServiceProtocol) {
        
        self.videoService = videoService
    }
    
    @MainActor
    func uploadVideo() async {
        isLoaded = false
        
        do {
            guard let lId = locationId else { return }
            guard let item = selectedItem else { return }
            guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
            await videoService.uploadVideoStorage(withData: videoData, locationId: lId)
            
            isLoaded = true
        } catch {
            print("DEBUG: ERROR: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchVideoByLocation() async {
        
        do {
            guard let lId = self.locationId else { return }
            self.locationVideo = try await videoService.fetchVideosByLocation(lId)
        } catch {
            print("ERROR FETCH VIDEOS: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func uploadTitle(vId: String, title: String) async {
        do {
            try await videoService.updatTitle(vId: vId, title: title)
        } catch {
            print("ERROR UPDATE TITLE: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func deleteVideo(_ videoId: String) async {
        await videoService.deleteVideo(videoId: videoId)
        await fetchVideoByLocation()
    }
}
