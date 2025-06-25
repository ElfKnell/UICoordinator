//
//  PhotoViewModelFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/06/2025.
//

import Foundation

@MainActor
final class PhotoViewModelFactory {
    
    static func make() -> PhotoViewModel {
        PhotoViewModel(
            photoService: PhotoService(),
            photoUploadService: PhotoUploadToFirebase()
        )
    }
}
