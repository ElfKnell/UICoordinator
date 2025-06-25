//
//  VideoUploadToFirebaseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/06/2025.
//

import Foundation

protocol VideoUploadToFirebaseProtocol {
    
    func uploadVideoStorage(withData videoData: Data, locationId: String) async throws
    
}
