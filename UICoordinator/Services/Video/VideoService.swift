//
//  VideoService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import Firebase
import FirebaseStorage

class VideoService: VideoServiceProtocol {
    
    func uploadVideoStorage(withData videoData: Data, locationId: String) async {
        
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
            await uploadVideo(video)
        } catch {
            print("ERROR WHILE UPLOADING VIDEO: \(error.localizedDescription)")
        }
    }
    
    private func uploadVideo(_ video: Video) async {
        
        do {
            guard let videoData = try? Firestore.Encoder()
                .encode(video) else { return }
            
            try await Firestore.firestore()
                .collection("Video")
                .addDocument(data: videoData)
        } catch {
            print("ERROR WHILE UPLOADING VIDEO: \(error.localizedDescription)")
        }
    }
    
    func fetchVideosByLocation(_ locationId: String) async throws -> [Video] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection("Video")
            .whereField("locationUid", isEqualTo: locationId)
            .getDocuments()
        let videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self)})
        return videos.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    func updatTitle(vId:String, title: String) async throws {
        
        try await Firestore.firestore()
            .collection("Video")
            .document(vId)
            .updateData(["title": title])
    }
    
    func deleteVideo(videoId: String) async throws {
        
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
        
    }

}
