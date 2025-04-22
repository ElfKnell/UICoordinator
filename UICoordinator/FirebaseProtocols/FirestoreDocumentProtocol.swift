//
//  FirestoreDocumentProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation

protocol FirestoreDocumentProtocol {
    func updateData(_ data: [String: Any]) async throws
}
