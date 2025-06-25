//
//  VideoServiceError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/06/2025.
//

import Foundation

enum VideoServiceError: Error, LocalizedError {
    
    case invalidVideoData
    case videoTooLarge(currentSizeMB: Double, maxSizeMB: Double)
    case storageUploadFailed(Error)
    case storageDownloadURLFailed(Error)
    case firestoreEncodingFailed(Error)
    case firestoreUploadFailed(Error)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidVideoData:
            return "Invalid video data."
        case .videoTooLarge(let current, let max):
            return "The video size (\(String(format: "%.2f", current)) MB) exceeds the maximum allowed (\(String(format: "%.2f", max)) MB)."
        case .storageUploadFailed(let error):
            return "Failed to upload video to storage: \(error.localizedDescription)"
        case .storageDownloadURLFailed(let error):
            return "Failed to get download URL for video: \(error.localizedDescription)"
        case .firestoreEncodingFailed(let error):
            return "Failed to encode video data for Firestore: \(error.localizedDescription)"
        case .firestoreUploadFailed(let error):
            return "Failed to save video metadata to Firestore: \(error.localizedDescription)"
        case .unknownError(let error):
            return "An unknown error occurred during video upload: \(error.localizedDescription)"
        }
    }
}
