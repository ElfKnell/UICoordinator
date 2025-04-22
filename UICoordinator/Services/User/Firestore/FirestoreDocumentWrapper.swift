//
//  FirestoreDocumentWrapper.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


final class FirestoreDocumentWrapper: FirestoreDocumentProtocol {
    private let ref: DocumentReference

    init(ref: DocumentReference) {
        self.ref = ref
    }

    func updateData(_ data: [String: Any]) async throws {
        try await ref.updateData(data)
    }
}
