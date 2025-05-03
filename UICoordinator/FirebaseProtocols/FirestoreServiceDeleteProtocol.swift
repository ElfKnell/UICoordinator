//
//  FirestoreServiceDeleteProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

protocol FirestoreGeneralDeleteProtocol {
    func deleteDocument(from collection: String, documentId: String) async throws
}
