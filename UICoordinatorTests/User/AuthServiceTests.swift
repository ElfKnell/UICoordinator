//
//  AuthServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 27/04/2025.
//
import FirebaseAuth
import XCTest

@MainActor
final class AuthServiceTests: XCTestCase {

    func testLoginSuccessUpdatesUserSession() async {
        let mockUserService = MockCurrentUserService()
        let fakeUser = MockFirebaseUser(uid: "123", email: "test@test.com")
        let mockAuthProvider = MockFirebaseAuthProvider()
        mockAuthProvider.mockUser = fakeUser
        
        let authService = AuthService(
            currentUserService: mockUserService,
            authProvider: mockAuthProvider
        )

        await authService.login(withEmail: "test@test.com", password: "123456")
        
        XCTAssertNotNil(authService.userSession)
        XCTAssertEqual(authService.userSession?.uid, fakeUser.uid)
        XCTAssertNil(authService.errorMessage)
        XCTAssertEqual(mockUserService.fetchCalledWithUserId, fakeUser.uid)
    }

    func testSignOutClearUserSession() {
        
        let mockUserService = MockCurrentUserService()
        let mockAuthProvider = MockFirebaseAuthProvider()
        
        let authService = AuthService(currentUserService: mockUserService,
                                      authProvider: mockAuthProvider)
        
        authService.userSession = MockFirebaseUser(uid: "123", email: "test@test.com")
        mockUserService.currentUser = DeveloperPreview.user
        
        authService.signOut()
        
        XCTAssertNil(authService.userSession)
        XCTAssertNil(mockUserService.currentUser)
    }
}
