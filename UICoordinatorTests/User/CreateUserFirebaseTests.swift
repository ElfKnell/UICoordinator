//
//  CreateUserFirebaseTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import XCTest

final class CreateUserFirebaseTests: XCTestCase {

    func testUploadUserData_CallsFirestoreWithCorrectData() async throws {

        let mockFirestore = MockCreateFirestoreService()
        let sut = CreateUserFirebase(firestoreService: mockFirestore)
            
        let userId = "user123"
        let email = "test@example.com"
        let fullname = "John Doe"
        let username = "johndoe"
        let isDelete = false

        try await sut.uploadUserData(id: userId, withEmail: email, fullname: fullname, username: username)

        XCTAssertTrue(mockFirestore.didCallSetData)
        XCTAssertEqual(mockFirestore.receivedId, userId)
        XCTAssertEqual(mockFirestore.receivedData?["email"] as? String, email)
        XCTAssertEqual(mockFirestore.receivedData?["fullname"] as? String, fullname)
        XCTAssertEqual(mockFirestore.receivedData?["username"] as? String, username)
        XCTAssertEqual(mockFirestore.receivedData?["isDelete"] as? Bool, isDelete)
    }
}
