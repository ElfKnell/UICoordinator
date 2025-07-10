//
//  MockStorage.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation

class MockStorage: StorageProtocol {

    let mockReference = MockStorageReference()

    func storageReference(withPath path: String) -> any StorageReferenceProtocol {
        return mockReference
    }
    
    func storageReference(forURL url: String) -> any StorageReferenceProtocol {
        return mockReference
    }
}
