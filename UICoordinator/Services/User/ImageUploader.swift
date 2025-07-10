//
//  ImageUploader.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/02/2024.
//

import Foundation
import Firebase
import FirebaseStorage

class ImageUploader: ImageUploaderProtocol {
    
    private let maxPhotoSize: Int = 2 * 1024 * 1024
    private let storage: StorageProtocol
    
    init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    func uploadeImage(_ image: UIImage, currentUser: User) async throws -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        
        if imageData.count > maxPhotoSize {
            let currentSizeMB = Double(imageData.count) / 1024 / 1024
            let maxSizeMB = Double(maxPhotoSize) / 1024 / 1024
            throw UserError.imageTooLarge(currentSizeMB: currentSizeMB, maxSizeMB: maxSizeMB)
        }
        
        let filename = NSUUID().uuidString
        let storegeRef = storage.storageReference(withPath: "profile_images/\(filename)")
        
        do {
            let _ = try await storegeRef.putDataAsyncRef(imageData)
            let url = try await storegeRef.downloadURL()
            
            try await deleteImage(currentUser: currentUser)
            
            return url.absoluteString
        } catch {
            throw UserError.imageUploadError(error)
        }
    }
    
    func deleteImage(currentUser: User)  async throws {
        
        guard let photoURL = currentUser.profileImageURL else { return }
        let storageRef = storage.storageReference(forURL: photoURL)
        
        try await storageRef.delete()
        
    }
}
