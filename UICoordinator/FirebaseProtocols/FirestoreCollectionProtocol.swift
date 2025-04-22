//
//  FirestoreCollectionProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation

protocol FirestoreCollectionProtocol {
    func document(_ id: String) -> FirestoreDocumentProtocol
}
