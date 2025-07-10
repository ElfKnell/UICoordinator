//
//  UserMockTransaction.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/06/2025.
//

import Foundation
import Firebase

class MockTransaction: TransactionProtocol {
    
    var mockGetDocuments: [String: DocumentSnapshotProtocol] = [:]
    var capturedSetDataCodable: [String: Encodable] = [:]
    var capturedSetDataDictionary: [String: [String: Any]] = [:]
    var capturedUpdateData: [String: [AnyHashable: Any]] = [:]
    var capturedDeleteDocument: [String] = []
    var getDocumentShouldThrow: Error?
    var getDocumentErrors: [String: Error] = [:]
    
    var setDataShouldThrow: Error?
    var updateDataShouldThrow: Error?
    var deleteDocumentShouldThrow: Error?
    
    func configureGetDocument(path: String, exists: Bool, data: [String: Any]? = nil) {
        mockGetDocuments[path] = MockDocumentSnapshot(documentID: URL(fileURLWithPath: path).lastPathComponent, exists: exists, data: data)
    }
    
    func configureGetDocumentError(path: String, error: Error) {
        getDocumentErrors[path] = error
    }
    
    func getDocument(_ documentRef: DocumentReference) throws -> DocumentSnapshotProtocol {
        if let error = getDocumentErrors[documentRef.documentID] {
            throw error
        }
        
        if let error = getDocumentShouldThrow {
            throw error
        }
        
        return mockGetDocuments[documentRef.documentID] ?? MockDocumentSnapshot(documentID: documentRef.documentID, exists: false)
    }
    
    func setData<T: Encodable>(from value: T, forDocument document: DocumentReference) throws {
        
        if let error = setDataShouldThrow {
            throw error
        }
        capturedSetDataCodable[document.documentID] = value
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(value)
        if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            capturedSetDataDictionary[document.documentID] = dict
        }
    }
    
    func setData(_ data: [String : Any], forDocument document: DocumentReference) throws {
        
        if let error = setDataShouldThrow {
            throw error
        }
        capturedSetDataDictionary[document.documentID] = data
    }
    
    func updateData(_ fields: [AnyHashable : Any], forDocument document: DocumentReference) throws {
        
        if let error = updateDataShouldThrow {
            throw error
        }
        capturedUpdateData[document.documentID] = fields
    }
    
    func deleteDocument(_ documentRef: DocumentReference) throws {
        
        if let error = deleteDocumentShouldThrow {
            throw error
        }
        capturedDeleteDocument.append(documentRef.documentID)
    }
    
    func collection(_ collectionPath: String) -> CollectionReference {
        
        return Firestore.firestore().collection(collectionPath)
    }
}
