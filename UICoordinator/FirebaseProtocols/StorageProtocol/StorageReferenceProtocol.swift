//
//  StorageReferenceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation
import FirebaseStorage

protocol StorageReferenceProtocol {
    
    var fullPath: String { get }
    func putDataAsyncRef(_ uploadData: Data) async throws -> StorageMetadata
    func downloadURL() async throws -> URL
    func delete() async throws
    
}
