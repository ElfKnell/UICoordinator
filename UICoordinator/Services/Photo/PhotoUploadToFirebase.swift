//
//  PhotoUploadToFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2025.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class PhotoUploadToFirebase: PhotoUploadToFirebaseProtocol {
    
    private let maxPhotoSize: Int = 5 * 1024 * 1024
    
    func uploadePhotoStorage(_ photo: UIImage, locationId: String, namePhoto: String) async throws {
        
        
            guard let photoData = photo.jpegData(compressionQuality: 0.9) else {
                throw PhotoServiceError.invalidImageData
            }
            
            if photoData.count > maxPhotoSize {
                let currentSizeMB = Double(photoData.count) / 1024 / 1024
                let maxSizeMB = Double(maxPhotoSize) / 1024 / 1024
                throw PhotoServiceError.photoTooLarge(currentSizeMB: currentSizeMB, maxSizeMB: maxSizeMB)
            }
            
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
            
        } catch let storageError as StorageErrorCode {
            throw PhotoServiceError.storageUploadFailed(storageError)
        } catch {
            throw PhotoServiceError.storageUploadFailed(error)
        }
    }
    
    private func uploadePhoto(_ photo: Photo) async throws {
        
        do {
            let photoData = try Firestore.Encoder()
                .encode(photo)
            
            try await Firestore.firestore()
                .collection("photos")
                .addDocument(data: photoData)
            
        } catch let encodingError as EncodingError {
            throw PhotoServiceError.firestoreEncodingFailed(encodingError)
        } catch {
            throw PhotoServiceError.firestoreUploadFailed(error)
        }
    }
}
