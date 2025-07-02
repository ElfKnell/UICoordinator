//
//  UserMockDocumentSnapshot.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/06/2025.
//

import Foundation
import Firebase

class UserMockDocumentSnapshot: DocumentSnapshotProtocol {
    
    var documentID: String
    var exists: Bool
    var _data: [String: Any]?
    
    init(documentID: String, exists: Bool, data: [String : Any]? = nil) {
        self.documentID = documentID
        self.exists = exists
        self._data = data
    }
    
    func data() -> [String : Any]? {
        return _data
    }
    
    func decodeData<T: Decodable>(as type: T.Type) throws -> T {
        guard let _data else {
            throw UserError.invalidType
        }
        
        if type == UniqueUsernameEntry.self {
            guard let userId = _data["userId"] as? String else {
                throw UserError.invalidType
            }
            let time = _data["time"] as? Timestamp
            return UniqueUsernameEntry(userId: userId, time: time) as! T
        } else if type == User.self {
            guard let id = _data["id"] as? String,
                  let fullname = _data["fullname"] as? String,
                  let username = _data["username"] as? String,
                  let email = _data["email"] as? String,
                  let isDelete = _data["isDelete"] as? Bool else {
                throw UserError.invalidType
            }
            return User(id: id,
                        fullname: fullname,
                        username: username,
                        email: email,
                        isDelete: isDelete) as! T
        }
        fatalError("MyMockDocumentSnapshot.decodeData(as:) not mocked fot type: \(T.self)")
    }
}
