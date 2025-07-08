//
//  FirebaseExtensions.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

extension DocumentSnapshot: DocumentSnapshotProtocol {
    func decodeData<T: Decodable>(as type: T.Type) throws -> T {
        try self.data(as: type)
    }
}

extension AuthDataResult: AuthDataResultProtocol {
    var firebaseUser: FirebaseUserProtocol {
        return self.user as FirebaseUserProtocol
    }
}

extension FirebaseAuth.User: FirebaseUserProtocol {}
