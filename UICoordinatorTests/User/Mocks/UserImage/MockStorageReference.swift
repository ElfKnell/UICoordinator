//
//  MockStorageReference.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation
import FirebaseStorage

class MockStorageReference: StorageReferenceProtocol {
    
    var fullPath: String = "mock/path/to/file.jpg"
    var shouldThrowErrorOnPutData = false
    var shouldThrowErrorOnDownloadURL = false
    var shouldThrowErrorOnDelete = false
    var downloadURLToReturn: URL?
    var deletedPath: String?
    
    func reset() {
        fullPath = "mock/path/to/file.jpg"
        shouldThrowErrorOnPutData = false
        shouldThrowErrorOnDownloadURL = false
        shouldThrowErrorOnDelete = false
        downloadURLToReturn = nil
        deletedPath = nil
    }
    
    func putDataAsyncRef(_ uploadData: Data) async throws -> StorageMetadata {
        
        if shouldThrowErrorOnPutData {
            throw NSError(domain: "test",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to upload data"])
        }
        return StorageMetadata()
    }
    
    func downloadURL() async throws -> URL {
        
        if shouldThrowErrorOnDownloadURL {
            throw NSError(domain: "test",
                          code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
        }
        guard let url = downloadURLToReturn else {
            throw NSError(domain: "MockError",
                          code: 99,
                          userInfo: [NSLocalizedDescriptionKey: "Mock downloadURLToReturn was not set for this test case."])
        }
        return url
    }
    
    func delete() async throws {
        
        if shouldThrowErrorOnDelete {
            throw NSError(domain: "test",
                          code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to delete"])
        }
        deletedPath = self.fullPath
    }
}
