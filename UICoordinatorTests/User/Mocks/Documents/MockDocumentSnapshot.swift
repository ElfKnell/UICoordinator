//
//  MockDocumentSnapshot.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation
import FirebaseFirestore

class MockDocumentSnapshot: DocumentSnapshotProtocol {
    
    var documentID: String
    var exists: Bool
    var _data: [String: Any]?
    var decodeDataShouldThrow: Error?
    
    init(documentID: String, exists: Bool, data: [String : Any]? = nil) {
        self.documentID = documentID
        self.exists = exists
        self._data = data
    }
    
    func data() -> [String : Any]? {
        return _data
    }
    
    func decodeData<T>(as type: T.Type) throws -> T where T : Decodable {
        
        if let error = decodeDataShouldThrow {
            throw error
        }
        guard let data = _data else {
            throw UserError.userNotFound
        }
        
        if type == User.self {
            guard let id = data["id"] as? String,
                  let fullname = data["fullname"] as? String,
                  let username = data["username"] as? String,
                  let email = data["email"] as? String,
                  let isDelete = data["isDelete"] as? Bool else {
                throw UserError.invalidType
            }
            let profileImageURL = data["profileImageURL"] as? String
            
            return User(id: id,
                        fullname: fullname,
                        username: username,
                        email: email,
                        profileImageURL: profileImageURL,
                        isDelete: isDelete) as! T
        } else if type == UniqueUsernameEntry.self {
            guard let userId = data["userId"] as? String else {
                throw UserError.invalidType
            }
            let time = data["time"] as? Timestamp
            return UniqueUsernameEntry(userId: userId, time: time) as! T
        }
        
        fatalError("MockDocumentSnapshot.decodeData(as:) not implemented for type: \(T.self)")
    }
}
