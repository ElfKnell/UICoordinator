//
//  MockImageUploader.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation
import UIKit

class MockImageUploader: ImageUploaderProtocol {
    
    var uploadImageResult: Result<String?, Error>?
    var deleteImageCalled = false
    var deleteImageError: Error?
        
    var uploadedImage: UIImage?
    var uploadedUser: User?
    
    func uploadeImage(_ image: UIImage, currentUser: User) async throws -> String? {
        uploadedImage = image
        uploadedUser = currentUser
        switch uploadImageResult {
        case .success(let url):
            return url
        case .failure(let error):
            throw error
        case .none:
            return "https://mock.image.url/default.jpg"
        }
    }
    
    func deleteImage(currentUser: User) async throws {
        deleteImageCalled = true
        if let error = deleteImageError {
            throw error
        }
    }
}
