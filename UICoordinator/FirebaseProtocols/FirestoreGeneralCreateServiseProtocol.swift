//
//  FirestoreFolloweCreateServiseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

protocol FirestoreGeneralCreateServiseProtocol {
    func addDocument(from collection: String, data: [String: Any]) async throws
}
