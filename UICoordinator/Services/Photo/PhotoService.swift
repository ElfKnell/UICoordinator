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
    
    static func uploadePhotoStorage(_ photo: UIImage, locationId: String) async throws -> String? {
        guard let photoData = photo.jpegData(compressionQuality: 0.95) else { return nil }
        let filename = NSUUID().uuidString
        let storegeRef = Storage.storage().reference(withPath: "images/\(locationId)/\(filename)")
        
        do {
            let _ = try await storegeRef.putDataAsync(photoData)
            let url = try await storegeRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
    
    static func uploadePhoto(_ photo: Photo) async throws {
        guard let photoData = try? Firestore.Encoder().encode(photo) else { return }
        try await Firestore.firestore().collection("photos").addDocument(data: photoData)
    }
    
    static func fetchPhotoByLocation(_ locationId: String) async throws -> [Photo] {
        let snapshot = try await Firestore.firestore().collection("photos").whereField("locationUid", isEqualTo: locationId).getDocuments()
        
        let photos = snapshot.documents.compactMap({ try? $0.data(as: Photo.self) })
        return photos.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func updateNamePhoto(photoId: String, photoName: String) async throws {
        try await Firestore.firestore().collection("photos").document(photoId).updateData(["name": photoName])
    }
    
    static func deletePhoto(photo: Photo)  async throws {
        do {
            let storageRef = Storage.storage().reference(forURL: photo.photoURL)
            
            try await storageRef.delete()
            
            try await Firestore.firestore().collection("photos").document(photo.id).delete()
        } catch {
            print("Debuge: error delete - \(error.localizedDescription)")
        }
    }
}
