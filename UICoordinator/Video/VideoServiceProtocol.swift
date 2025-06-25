//
//  VideoServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/06/2025.
//

import Foundation

protocol VideoServiceProtocol {
    
    func uploadVideoStorage(withData videoData: Data, locationId: String) async
    
    func fetchVideosByLocation(_ locationId: String) async throws -> [Video]
    
    func updatTitle(vId:String, title: String) async throws
    
    func deleteVideo(videoId: String) async throws
    
}
