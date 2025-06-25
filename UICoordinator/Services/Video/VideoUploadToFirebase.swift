//
//  VideoUploadToFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/06/2025.
//

import Foundation
import Firebase
import FirebaseStorage

class VideoUploadToFirebase: VideoUploadToFirebaseProtocol {
    
    private let maxVideoSizeBytes: Int = 10 * 1024 * 1024
    
    func uploadVideoStorage(withData videoData: Data, locationId: String) async throws {
        
        if videoData.count > maxVideoSizeBytes {
            let currentSizeMB = Double(videoData.count) / 1024 / 1024
            let maxSizeMB = Double(maxVideoSizeBytes) / 1024 / 1024
            throw VideoServiceError.videoTooLarge(currentSizeMB: currentSizeMB, maxSizeMB: maxSizeMB)
        }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage()
            .reference()
            .child("videos/\(locationId)/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        do {
            let _ = try await ref.putDataAsync(videoData, metadata: metadata)
            let url = try await ref.downloadURL()
            let video = Video(locationUid: locationId, timestamp: Timestamp(), videoURL: url.absoluteString)
            try await uploadVideo(video)
        } catch let storageError as StorageErrorCode {
            throw VideoServiceError.storageUploadFailed(storageError)
        } catch {
            throw VideoServiceError.unknownError(error)
        }
    }
    
    private func uploadVideo(_ video: Video) async throws {
        
        do {
            guard let videoData = try? Firestore.Encoder()
                .encode(video) else {
                throw VideoServiceError.invalidVideoData
            }
            
            try await Firestore.firestore()
                .collection("Video")
                .addDocument(data: videoData)
        } catch let encodingError as EncodingError {
            throw VideoServiceError.firestoreEncodingFailed(encodingError)
        } catch {
            throw VideoServiceError.firestoreUploadFailed(error)
        }
    }
    
}
