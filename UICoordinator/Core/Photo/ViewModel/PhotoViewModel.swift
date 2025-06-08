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
    
    let photoService = PhotoService()
    
    @Published var switcher = PhotoSwitch.noPhoto
    
    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                await setImage(selectedItem)
            }
        }
    }
    
    func uploadPhoto(locationId: String) async {
        self.isLoading = true
        
        guard let image = selectedImage else { return }
        let name = self.namePhoto
        if name == "" { return }
        await photoService
            .uploadePhotoStorage(image, locationId: locationId, namePhoto: name)
        
        await fetchPhoto(locationId)
        
        clean()
        self.isLoading = false
    }
    
    private func setImage(_ selectedItem: PhotosPickerItem?) async {
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
    
    func fetchPhoto(_ locationId: String) async {
        
        do {
            self.isLoading = true
            self.photos = try await photoService.fetchPhotosByLocation(locationId)
            self.isLoading = false
        } catch {
            print("ERROR FETCHING PHOTO: \(error.localizedDescription)")
        }
    }
    
    func updatePhotoName() async {
        do {
            isLoading = true
            guard let photo = self.photo else { return }
            if self.namePhoto == "" { return }
            try await photoService.updateNamePhoto(photoId: photo.id, photoName: self.namePhoto)
            
            await fetchPhoto(photo.locationUid)
            clean()
            isLoading = false
        } catch {
            print("ERROR UPDATE NAME PHOTO: \(error.localizedDescription)")
        }
    }
    
    func deletePhoto() async {
        isLoading = true
        
        guard let photo = self.photo else { return }
        
        await photoService.deletePhoto(photo: photo)
        
        await fetchPhoto(photo.locationUid)
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
