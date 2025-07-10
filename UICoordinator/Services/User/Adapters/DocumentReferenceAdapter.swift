//
//  DocumentReferenceAdapter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation
import Firebase

class DocumentReferenceAdapter: DocumentReferenceProtocol {
    
    private let reference: DocumentReference
    var documentId: String {
        reference.documentID
    }
    
    init(reference: DocumentReference) {
        self.reference = reference
    }
    
    func updateData(_ fields: [AnyHashable: Any]) async throws {
        try await reference.updateData(fields)
    }
    
    func setData<T: Encodable>(from value: T) async throws {
        try reference.setData(from: value)
    }

    func setData(_ data: [String: Any]) async throws {
        try await reference.setData(data)
    }

    func delete() async throws {
        try await reference.delete()
    }
}
