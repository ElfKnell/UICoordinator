//
//  VideoViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/03/2024.
//

import Firebase
import PhotosUI
import SwiftUI

@MainActor
class VideoViewModel: ObservableObject {
    
    @Published var isLoaded = true
    @Published var locationVideo = [Video]()
    @Published var locationId: String?
    
    @Published var activeError: String? {
        didSet {
            isError = activeError != nil
        }
    }
    @Published var isError = false
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                await uploadVideo()
            }
        }
    }
    
    private let videoService: VideoServiceProtocol
    private let videoUploadService: VideoUploadToFirebaseProtocol
    
    init(videoService: VideoServiceProtocol,
         videoUploadService: VideoUploadToFirebaseProtocol) {
        
        self.videoService = videoService
        self.videoUploadService = videoUploadService
    }
    
    @MainActor
    func uploadVideo() async {
        
        isLoaded = false
        self.activeError = nil
        
        do {
            
            guard let lId = locationId else { return }
            guard let item = selectedItem else { return }
            guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
            try await videoUploadService.uploadVideoStorage(withData: videoData, locationId: lId)
            
        } catch let errorVideo as VideoServiceError {
            self.activeError = errorVideo.localizedDescription
        } catch {
            self.activeError = VideoServiceError.unknownError(error).localizedDescription
        }
        
        isLoaded = true
    }
    
    @MainActor
    func fetchVideoByLocation() async {
        
        self.activeError = nil
        
        do {
            guard let lId = self.locationId else { return }
            self.locationVideo = try await videoService.fetchVideosByLocation(lId)
        } catch {
            self.activeError = "ERROR FETCH VIDEOS: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func uploadTitle(vId: String, title: String) async {
        
        self.activeError = nil
        
        do {
            try await videoService.updatTitle(vId: vId, title: title)
        } catch {
            self.activeError = "ERROR UPDATE TITLE: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func deleteVideo(_ video: Video) async {
        
        self.activeError = nil
        
        do {
            try await videoService.deleteVideo(video: video)
            await fetchVideoByLocation()
        } catch {
            self.activeError = "ERROR DELETE VIDEO: \(error.localizedDescription)"
        }
    }
}
