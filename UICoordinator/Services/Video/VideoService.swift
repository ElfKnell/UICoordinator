//
//  VideoService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

//import Firebase
//import FirebaseStorage
//
//class VideoService: VideoServiceProtocol {
//    
//    func uploadVideoStorage(withData videoData: Data, locationId: String) async throws {
//        
//        let filename = NSUUID().uuidString
//        let ref = Storage.storage()
//            .reference()
//            .child("videos/\(locationId)/\(filename)")
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "video/quicktime"
//        
//        let _ = try await ref.putDataAsync(videoData, metadata: metadata)
//        let url = try await ref.downloadURL()
//        let video = Video(locationUid: locationId, timestamp: Timestamp(), videoURL: url.absoluteString)
//        try await uploadVideo(video)
//        
//    }
//    
//    private func uploadVideo(_ video: Video) async throws {
//        
//        guard let videoData = try? Firestore.Encoder()
//            .encode(video) else { return }
//        
//        try await Firestore.firestore()
//            .collection("video")
//            .addDocument(data: videoData)
//        
//    }
//    
//    func fetchVideosByLocation(_ locationId: String) async throws -> [Video] {
//        
//        let snapshot = try await Firestore
//            .firestore()
//            .collection("video")
//            .whereField("locationUid", isEqualTo: locationId)
//            .getDocuments()
//        let videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self)})
//        return videos.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
//    }
//    
//    func updatTitle(vId:String, title: String) async throws {
//        
//        try await Firestore.firestore()
//            .collection("video")
//            .document(vId)
//            .updateData(["title": title])
//    }
//    
//    func deleteVideo(video: Video) async throws {
//        
//        let storageRef = Storage.storage().reference(forURL: video.videoURL)
//        
//        try await storageRef.delete()
//        
//        try await Firestore.firestore()
//            .collection("video")
//            .document(video.id).delete()
//        
//    }
//
//}
