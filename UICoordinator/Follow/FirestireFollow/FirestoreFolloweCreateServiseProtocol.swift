//
//  FirestoreFolloweCreateServiseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

protocol FirestoreFolloweCreateServiseProtocol {
    func addDocument(data: [String: Any]) async throws
}
