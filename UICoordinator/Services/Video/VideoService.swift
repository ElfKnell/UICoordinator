//
//  VideoService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import Firebase
import FirebaseStorage

class VideoService {
    
    static func uploadVideoStorage(withData videoData: Data, locationId: String) async -> String? {
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage()
            .reference()
            .child("videos/\(locationId)/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        do {
            let _ = try await ref.putDataAsync(videoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            return nil
        }
    }
    
    static func uploadVideo(_ video: Video) async throws {
        
        guard let videoData = try? Firestore.Encoder()
            .encode(video) else { return }
        
        try await Firestore.firestore()
            .collection("Video")
            .addDocument(data: videoData)
    }
    
    static func fetchVideosByLocation(_ locationId: String) async throws -> [Video] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection("Video")
            .whereField("locationUid", isEqualTo: locationId)
            .getDocuments()
        let videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self)})
        return videos.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func updatTitle(vId:String, title: String) async throws {
        
        try await Firestore.firestore()
            .collection("Video")
            .document(vId)
            .updateData(["title": title])
    }
    
    static func deleteVideo(videoId: String) async {
        
        do {
            let snapshot = try await Firestore.firestore()
                .collection("Video")
                .document(videoId)
                .getDocument()
            
            let video = try snapshot.data(as: Video.self)
            
            let storageRef = Storage.storage().reference(forURL: video.videoURL)
            
            try await storageRef.delete()
            
            try await Firestore.firestore()
                .collection("Video")
                .document(video.id).delete()
            
        } catch {
            print("DEBUGE: error delete - \(error.localizedDescription)")
        }
    }

}
