//
//  PhotoService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseCrashlytics

class PhotoService: PhotoServiceProtocol {
    
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
    
    func deletePhoto(photo: Photo)  async throws {
        
        let storageRef = Storage.storage()
            .reference(forURL: photo.photoURL)
        
        try await storageRef.delete()
        
        try await Firestore.firestore()
            .collection("photos")
            .document(photo.id)
            .delete()
    }
    
    func deletePhotoByLocation(_ locationId: String) async throws {
        
        let photos = try await fetchPhotosByLocation(locationId)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for photo in photos {
                group.addTask {
                    do {
                        try await self.deletePhoto(photo: photo)
                    } catch {
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
            }
            
            try await group.waitForAll()
        }
        
    }
}
