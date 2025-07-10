//
//  MockDocumentReference.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation

class MockDocumentReference: DocumentReferenceProtocol {
    
    var documentId: String
    private let onUpdate: ((String, [AnyHashable: Any]) -> Void)?
        
    var _capturedUpdateData: [AnyHashable: Any]? = nil
    var _capturedSetDataCodable: Encodable? = nil
    var _capturedSetDataDictionary: [String: Any]? = nil
    var _capturedDelete: Bool = false

    var shouldThrowErrorOnUpdate: Error?
    var shouldThrowErrorOnSet: Error?
    var shouldThrowErrorOnDelete: Error?
    
    init(documentID: String, onUpdate: ((String, [AnyHashable: Any]) -> Void)? = nil) {
        self.documentId = documentID
        self.onUpdate = onUpdate
    }
    
    func updateData(_ fields: [AnyHashable : Any]) async throws {
        
        _capturedUpdateData = fields
        
        if let error = shouldThrowErrorOnUpdate {
            throw error
        }
        onUpdate?(documentId, fields)
    }
    
    func setData<T>(from value: T) async throws where T : Encodable {
        
        _capturedSetDataCodable = value
        
        if let error = shouldThrowErrorOnSet {
            throw error
        }
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(value)
        if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            _capturedSetDataDictionary = dict
        }
    }
    
    func setData(_ data: [String : Any]) async throws {
        
        _capturedSetDataDictionary = data
        if let error = shouldThrowErrorOnSet {
            throw error
        }
        onUpdate?(documentId, data)
    }
    
    func delete() async throws {
        
        _capturedDelete = true
        if let error = shouldThrowErrorOnDelete {
            throw error
        }
    }
}
