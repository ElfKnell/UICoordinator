//
//  FirebaseStorageExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation
import Firebase
import FirebaseStorage

extension StorageReference: StorageReferenceProtocol {
    func putDataAsyncRef(_ uploadData: Data) async throws -> FirebaseStorage.StorageMetadata {
        return try await self.putDataAsync(uploadData)
    }
}

extension Storage: StorageProtocol {
    
    func storageReference(withPath path: String) -> StorageReferenceProtocol {
        return self.reference(withPath: path)
    }
    
    func storageReference(forURL url: String) -> StorageReferenceProtocol {
        return self.reference(forURL: url)
    }
}
