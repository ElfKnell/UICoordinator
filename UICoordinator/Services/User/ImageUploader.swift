//
//  ImageUploader.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/02/2024.
//

import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadeImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = NSUUID().uuidString
        let storegeRef = Storage.storage().reference(withPath: "profile_images/\(filename)")
        
        do {
            let _ = try await storegeRef.putDataAsync(imageData)
            let url = try await storegeRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}
