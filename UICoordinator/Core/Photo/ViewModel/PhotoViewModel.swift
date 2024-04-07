//
//  PhotoViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI
import PhotosUI
import Firebase

@MainActor
class PhotoViewModel : ObservableObject {
    
    @Published var photos = [Photo]()
    @Published var photo: Photo?
    @Published var namePhoto = ""
    @Published var isLoading = false
    
    @Published var switcher = PhotoSwitch.noPhoto
    
    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await setImage(selectedItem)
            }
        }
    }
    
    func uploadPhoto(locationId: String) async throws {
        self.isLoading = true
        
        guard let image = selectedImage else { return }
        guard let photoURL = try await PhotoService.uploadePhotoStorage(image, locationId: locationId) else { return }
        let photo = Photo(locationUid: locationId, name: self.namePhoto, timestamp: Timestamp(), photoURL: photoURL)
        try await PhotoService.uploadePhoto(photo)
        
        try await fetchPhoto(locationId)
        
        clean()
        self.isLoading = false
    }
    
    func setImage(_ selectedItem: PhotosPickerItem?) async throws {
        do {
            guard let item = selectedItem else { return }
            let data = try await item.loadTransferable(type: Data.self)
            guard let data, let uiImage = UIImage(data: data) else { return }
            self.selectedImage = uiImage
            
            switcher = .newPhoto
        } catch {
            print("Debug: set image error: \(error.localizedDescription)")
        }
    }
    
    func fetchPhoto(_ locationId: String) async throws {
        self.photos = try await PhotoService.fetchPhotoByLocation(locationId)
    }
    
    func updatePhotoName() async throws {
        isLoading = true
        guard let photo = self.photo else { return }
        try await PhotoService.updateNamePhoto(photoId: photo.id, photoName: self.namePhoto)
        
        try await fetchPhoto(photo.locationUid)
        clean()
        isLoading = false
    }
    
    func deletePhoto() async throws {
        isLoading = true
        
        guard let photo = self.photo else { return }
        
        try await PhotoService.deletePhoto(photo: photo)
        
        try await fetchPhoto(photo.locationUid)
        clean()
        isLoading = false
    }
    
    func clean() {
        self.selectedItem = nil
        self.selectedImage = nil
        self.photo = nil
        self.namePhoto = ""
        self.switcher = .noPhoto
    }
    
    
}
