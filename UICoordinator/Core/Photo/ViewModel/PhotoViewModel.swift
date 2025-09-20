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
    
    @Published var activeError: String? {
        didSet {
            isError = activeError != nil
        }
    }
    @Published var isError = false

    @Published var switcher = PhotoSwitch.noPhoto
    
    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                await setImage(selectedItem)
            }
        }
    }
    
    let photoService: PhotoServiceProtocol
    let photoUploadService: PhotoUploadToFirebaseProtocol
    let contentModerator: ContentModeratorProtocol
    
    init(photoService: PhotoServiceProtocol,
         photoUploadService: PhotoUploadToFirebaseProtocol,
         contentModerator: ContentModeratorProtocol) {
        self.photoService = photoService
        self.photoUploadService = photoUploadService
        self.contentModerator = contentModerator
    }
    
    func uploadPhoto(locationId: String) async {
        
        self.isLoading = true
        self.activeError = nil
        
        do {
            
            guard let image = selectedImage else {
                throw PhotoServiceError.invalidImage
            }
            
            let name = self.namePhoto
            if name == "" {
                throw PhotoServiceError.missingPhotoName
            }
            
            let result = try await contentModerator.checkImage(image: image)
            guard !result else {
                throw ModerationError.invalidImage
            }
            
            try await photoUploadService
                .uploadePhotoStorage(image, locationId: locationId, namePhoto: name)
            
            await fetchPhoto(locationId)
            
            clean()
            
            
        } catch let error as PhotoServiceError {
            self.activeError = error.localizedDescription
        } catch {
            self.activeError = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    private func setImage(_ selectedItem: PhotosPickerItem?) async {
        
        self.activeError = nil
        
        do {
            guard let item = selectedItem else { return }
            let data = try await item.loadTransferable(type: Data.self)
            guard let data, let uiImage = UIImage(data: data) else { return }
            self.selectedImage = uiImage
            
            switcher = .newPhoto
        } catch {
            self.activeError = "Set image error: \(error.localizedDescription)"
        }
    }
    
    func fetchPhoto(_ locationId: String) async {
        
        self.isLoading = true
        self.activeError = nil
        
        do {
            
            self.photos = try await photoService.fetchPhotosByLocation(locationId)
            
        } catch {
            self.activeError = "ERROR FETCHING PHOTO: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func updatePhotoName() async {
        
        isLoading = true
        self.activeError = nil
        
        do {
            
            guard let photo = self.photo else { return }
            if self.namePhoto == "" { return }
            try await photoService.updateNamePhoto(photoId: photo.id, photoName: self.namePhoto)
            
            await fetchPhoto(photo.locationUid)
            clean()
            
        } catch {
            self.activeError = "ERROR UPDATE NAME PHOTO: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func deletePhoto() async {
        
        isLoading = true
        self.activeError = nil
        
        do {
            guard let photo = self.photo else { return }
            
            try await photoService.deletePhoto(photo: photo)
            
            await fetchPhoto(photo.locationUid)
            
            clean()
            
        } catch {
            self.activeError = "ERROR DELETE PHOTO: \(error.localizedDescription)"
        }
        
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
