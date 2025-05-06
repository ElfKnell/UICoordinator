//
//  FirestoreLikeCreateServiseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/05/2025.
//

import Foundation

protocol FirestoreLikeCreateServiseProtocol {
    func addDocument(collectionName: CollectionNameForLike, data: [String: Any]) async throws
}
