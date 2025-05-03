//
//  CurrentUserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import XCTest

final class CurrentUserServiceTests: XCTestCase {

    func testFetchCurrentUser_setsCurrentUserSuccessfully() async throws {

        let mockUserData: User = User(
                id: "user_123",
                fullname: "Test Name",
                username: "TestUser",
                email: "exaple@example.com",
                isDelete: false
        )
            
        let mockFirestore = MockFirestoreService()
        mockFirestore.mockUser = mockUserData


        let service = CurrentUserService(firestoreService: mockFirestore)

        try await service.fetchCurrentUser(userId: "user_123")

        XCTAssertEqual(service.currentUser?.id, "user_123")
        XCTAssertEqual(service.currentUser?.fullname, "Test Name")
        XCTAssertEqual(service.currentUser?.username, "TestUser")
        XCTAssertEqual(service.currentUser?.email, "exaple@example.com")
        XCTAssertEqual(service.currentUser?.isDelete, false)
        
    }

    func testFetchCurrentUser_setsCurrentUserFail() async throws {
        
        let mockFirestore = MockFirestoreService()
        mockFirestore.mockUser = DeveloperPreview.user
        let servise = CurrentUserService(firestoreService: mockFirestore)
        
        do {
            try await servise.fetchCurrentUser(userId: nil)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is UserError)
        }
    }
}
