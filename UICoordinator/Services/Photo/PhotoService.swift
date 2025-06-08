//
//  PhotoService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage

class  PhotoService {
    
    func uploadePhotoStorage(_ photo: UIImage, locationId: String, namePhoto: String) async {
        
        guard let photoData = photo.jpegData(compressionQuality: 0.95) else { return }
        let filename = NSUUID().uuidString
        let storegeRef = Storage.storage()
            .reference(withPath: "images/\(locationId)/\(filename)")
        
        do {
            let _ = try await storegeRef.putDataAsync(photoData)
            let url = try await storegeRef.downloadURL()
            let photo = Photo(locationUid: locationId,
                              name: namePhoto,
                              timestamp: Timestamp(),
                              photoURL: url.absoluteString)
            
            try await uploadePhoto(photo)
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
        }
    }
    
    private func uploadePhoto(_ photo: Photo) async throws {
        
        guard let photoData = try? Firestore.Encoder()
            .encode(photo) else { return }
        
        try await Firestore.firestore()
            .collection("photos")
            .addDocument(data: photoData)
    }
    
    func fetchPhotosByLocation(_ locationId: String) async throws -> [Photo] {
        
        let snapshot = try await Firestore.firestore()
            .collection("photos")
            .whereField("locationUid", isEqualTo: locationId).getDocuments()
        
        let photos = snapshot.documents.compactMap({ try? $0.data(as: Photo.self) })
        return photos.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    func updateNamePhoto(photoId: String, photoName: String) async throws {
        try await Firestore.firestore()
            .collection("photos")
            .document(photoId)
            .updateData(["name": photoName])
    }
    
    func deletePhoto(photo: Photo)  async {
        do {
            let storageRef = Storage.storage()
                .reference(forURL: photo.photoURL)
            
            try await storageRef.delete()
            
            try await Firestore.firestore()
                .collection("photos")
                .document(photo.id)
                .delete()
        } catch {
            print("Debuge: error delete - \(error.localizedDescription)")
        }
    }
}
