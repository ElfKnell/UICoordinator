//
//  CurrentUserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import XCTest

final class CurrentUserServiceTests: XCTestCase {

    func testFetchCurrentUser_setsCurrentUserSuccessfully() async throws {
            // Arrange
        let mockUserData: [String: Any] = [
                "id": "user_123",
                "fullname": "Test Name",
                "username": "TestUser",
                "email": "exaple@example.com"
        ]
            
        let mockSnapshot = MockDocumentSnapshot(mockData: mockUserData)
        
        let mockFirestore = MockFirestoreService()
        mockFirestore.returnedSnapshot = mockSnapshot

        let service = CurrentUserService.sharedCurrent
        service.firestoreService = mockFirestore

            // Act
        await service.fetchCurrentUser(userId: "user_123")

            // Assert
        XCTAssertEqual(service.currentUser?.id, "user_123")
        XCTAssertEqual(service.currentUser?.fullname, "Test Name")
        XCTAssertEqual(service.currentUser?.username, "TestUser")
        XCTAssertEqual(service.currentUser?.email, "exaple@example.com")
        XCTAssertNoThrow(try mockSnapshot.decodeData(as: User.self))
    }

    func testFetchCurrentUser_whenNilUserId_doesNotCrash() async {
            // Arrange
        let mockFirestore = MockFirestoreService()
        let service = CurrentUserService.sharedCurrent
        service.firestoreService = mockFirestore // Inject the mock service

                // Act
        await service.fetchCurrentUser(userId: nil as String?)
                
                // Assert
        XCTAssertNil(service.currentUser)
    }

}
