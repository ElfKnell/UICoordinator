//
//  PhotoServiceError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2025.
//

import Foundation

enum PhotoServiceError: Error, LocalizedError {
    
    case invalidImageData
    case photoTooLarge(currentSizeMB: Double, maxSizeMB: Double)
    case storageUploadFailed(Error)
    case storageDownloadURLFailed(Error)
    case firestoreEncodingFailed(Error)
    case firestoreUploadFailed(Error)
    case invalidImage
    case missingPhotoName
    
    var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Failed to convert image to data."
        case .photoTooLarge(let current, let max):
            return "The photo size (\(String(format: "%.2f", current)) MB) exceeds the maximum allowed (\(String(format: "%.2f", max)) MB)."
        case .storageUploadFailed(let error):
            return "Failed to upload photo to storage: \(error.localizedDescription)"
        case .storageDownloadURLFailed(let error):
            return "Failed to get download URL for photo: \(error.localizedDescription)"
        case .firestoreEncodingFailed(let error):
            return "Failed to encode photo data for Firestore: \(error.localizedDescription)"
        case .firestoreUploadFailed(let error):
            return "Failed to save photo metadata to Firestore: \(error.localizedDescription)"
        case .invalidImage:
            return "No photos selected for upload."
        case .missingPhotoName:
            return "No photo title entered."
        }
    }
}
