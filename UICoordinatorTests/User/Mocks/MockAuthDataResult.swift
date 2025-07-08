//
//  MockAuthDataResult.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockAuthDataResult: AuthDataResultProtocol {
    
    var _firebaseUser: FirebaseUserProtocol
    
    init(firebaseUser: FirebaseUserProtocol) {
        self._firebaseUser = firebaseUser
    }
    
    var firebaseUser: FirebaseUserProtocol {
        return _firebaseUser
    }
}
