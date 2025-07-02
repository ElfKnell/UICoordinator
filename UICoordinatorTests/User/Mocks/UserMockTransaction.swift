//
//  UserMockTransaction.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/06/2025.
//

import Foundation
import Firebase

class UserMockTransaction: TransactionProtocol {
    
    var mockGetDocuments: [String: DocumentSnapshotProtocol] = [:]
    var capturedSetDataCodable: [String: Encodable] = [:]
    var capturedSetDataDictionary: [String: [String: Any]] = [:]
    var capturedUpdateData: [String: [AnyHashable: Any]] = [:]
    var capturedDeleteDocument: [String] = []
    var getDocumentShouldThrow: Error?
    
    func configureGetDocument(path: String, exists: Bool, data: [String: Any]? = nil) {
        mockGetDocuments[path] = UserMockDocumentSnapshot(documentID: URL(fileURLWithPath: path).lastPathComponent, exists: exists, data: data)
    }
    
    func getDocument(_ documentRef: DocumentReference) throws -> DocumentSnapshotProtocol {
        if let error = getDocumentShouldThrow {
            throw error
        }
        return mockGetDocuments[documentRef.path] ?? UserMockDocumentSnapshot(documentID: documentRef.documentID, exists: false)
    }
    
    func setData<T: Encodable>(from value: T, forDocument document: DocumentReference) throws {
        capturedSetDataCodable[document.path] = value
    }
    
    func setData(_ data: [String : Any], forDocument document: DocumentReference) throws {
        capturedSetDataDictionary[document.path] = data
    }
    
    func updateData(_ fields: [AnyHashable : Any], forDocument document: DocumentReference) throws {
        capturedUpdateData[document.path] = fields
    }
    
    func deleteDocument(_ documentRef: DocumentReference) throws {
        capturedDeleteDocument.append(documentRef.path)
    }
    
    func collection(_ collectionPath: String) -> CollectionReference {
        return Firestore.firestore().collection(collectionPath)
    }
}
