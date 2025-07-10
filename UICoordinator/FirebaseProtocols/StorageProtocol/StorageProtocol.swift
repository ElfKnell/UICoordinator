//
//  StorageProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation

protocol StorageProtocol {
    
    func storageReference(withPath path: String) -> StorageReferenceProtocol
    func storageReference(forURL url: String) -> StorageReferenceProtocol
    
}
