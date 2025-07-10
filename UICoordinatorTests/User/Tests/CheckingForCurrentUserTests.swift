//
//  CheckingForCurrentUserTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import XCTest

final class CheckingForCurrentUserTests: XCTestCase {
    
    let ownerID = "owner_uid_123"
    let matchingUserID = "owner_uid_123"
    let nonMatchingUserID = "other_uid_456"

    lazy var matchingUser: User = User(id: matchingUserID,
                                       fullname: "Owner User",
                                       username: "owner",
                                       email: "owner@example.com",
                                       isDelete: false)
    
    lazy var nonMatchingUser: User = User(id: nonMatchingUserID,
                                          fullname: "Other User",
                                          username: "other",
                                          email: "other@example.com",
                                          isDelete: false)
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_isOwnerCurrentUser_returnsTrue_whenIDsMatch() {
        
        let ownerUid = ownerID
        let currentUser: User? = matchingUser
        
        let isOwner = CheckingForCurrentUser.isOwnerCurrentUser(ownerUid, currentUser: currentUser)
        
        XCTAssertTrue(isOwner, "Should return true when currentUser ID matches ownerUid.")
    }
    
    func test_isOwnerCurrentUser_returnsFalse_whenIDsDoNotMatch() {
        
        let ownerUid = ownerID
        let currentUser: User? = nonMatchingUser
        
        let isOwner = CheckingForCurrentUser.isOwnerCurrentUser(ownerUid, currentUser: currentUser)
        
        XCTAssertFalse(isOwner, "Should return false when currentUser ID does not match ownerUid.")
    }

    func test_isOwnerCurrentUser_returnsFalse_whenCurrentUserIsNil() {
        
        let ownerUid = ownerID
        let currentUser: User? = nil
        
        let isOwner = CheckingForCurrentUser.isOwnerCurrentUser(ownerUid, currentUser: currentUser)
        
        XCTAssertFalse(isOwner, "Should return false when currentUser is nil.")
    }
    
    func test_isOwnerCurrentUser_returnsFalse_whenOwnerUidIsEmpty() {
        
        let ownerUid = ""
        let currentUser: User? = matchingUser
        
        let isOwner = CheckingForCurrentUser.isOwnerCurrentUser(ownerUid, currentUser: currentUser)
        
        XCTAssertFalse(isOwner, "Should return false when ownerUid is empty and currentUser exists.")
    }
}
