//
//  AuthServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 27/04/2025.
//
import FirebaseAuth
import Firebase
import XCTest

@MainActor
final class AuthServiceTests: XCTestCase {

    var mockCurrentUserService: MockCurrentUserService!
    var mockFirebaseAuthProvider: MockFirebaseAuthProvider!
    var mockFirebaseStaticAuthProvider: MockFirebaseStaticAuthProvider!
    var sut: AuthService!
    
    let testUserID = "mock_user_uid_543"
    let testEmail = "test3@example.com"
    let testPassword = "password123"
    
    override func setUp() {
        super.setUp()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        mockCurrentUserService = MockCurrentUserService()
        mockFirebaseAuthProvider = MockFirebaseAuthProvider()
        mockFirebaseStaticAuthProvider = MockFirebaseStaticAuthProvider()
        
        sut = AuthService(currentUserService: mockCurrentUserService,
                          authProvider: mockFirebaseAuthProvider,
                          authStaticProvider: mockFirebaseStaticAuthProvider)
    }
    
    override func tearDown() {
        
        sut = nil
        mockCurrentUserService = nil
        mockFirebaseAuthProvider = nil
        mockFirebaseStaticAuthProvider = nil
        super.tearDown()
    }
    
    func test_login_success() async throws {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockFirebaseAuthProvider.signInResult = mockUser
        mockCurrentUserService.fetchCurrentUserShouldThrow = nil
        
        await sut.login(withEmail: testEmail, password: testPassword)
        
        // 1. Verify sign-in was called with correct credentials
        XCTAssertTrue(mockFirebaseAuthProvider.signInCalled)
        XCTAssertEqual(mockFirebaseAuthProvider.capturedSignInEmail, testEmail)
        XCTAssertEqual(mockFirebaseAuthProvider.capturedSignInPassword, testPassword)
        
        // 2. Verify userSession is set
        XCTAssertNotNil(sut.userSession)
        XCTAssertEqual(sut.userSession?.uid, testUserID)
        XCTAssertEqual(sut.userSession?.email, testEmail)

        // 3. Verify fetchCurrentUser was called with correct UID
        XCTAssertTrue(mockCurrentUserService.fetchCurrentUserCalled)
        XCTAssertEqual(mockCurrentUserService.capturedFetchUserID, testUserID)

        // 4. Verify errorMessage is nil
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_login_failure_signInFails() async {
        
        let signInError = NSError(domain: AuthErrorDomain,
                                  code: AuthErrorCode.wrongPassword.rawValue,
                                  userInfo: [NSLocalizedDescriptionKey: "Wrong password."])
        mockFirebaseAuthProvider.signInShouldThrow = signInError
        
        await sut.login(withEmail: testEmail, password: testPassword)
        
        // 1. Verify sign-in was called
        XCTAssertTrue(mockFirebaseAuthProvider.signInCalled)
        
        // 2. Verify userSession is nil
        XCTAssertNil(sut.userSession)

        // 3. Verify errorMessage is set
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, signInError.localizedDescription)

        // 4. Verify fetchCurrentUser was NOT called
        XCTAssertFalse(mockCurrentUserService.fetchCurrentUserCalled)
    }
    
    func test_login_failure_fetchCurrentUserFails() async {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockFirebaseAuthProvider.signInResult = mockUser

        let fetchError = NSError(domain: "FirestoreErrorDomain",
                                 code: 1,
                                 userInfo: [NSLocalizedDescriptionKey: "User document not found."])
        mockCurrentUserService.fetchCurrentUserShouldThrow = fetchError

        await sut.login(withEmail: testEmail, password: testPassword)
        
        // 1. Verify sign-in was called
        XCTAssertTrue(mockFirebaseAuthProvider.signInCalled)

        // 2. Verify userSession is set (it would have been set briefly before fetch failed)
        XCTAssertNotNil(sut.userSession) // It remains set because it's not explicitly cleared on fetch error
        XCTAssertEqual(sut.userSession?.uid, testUserID)

        // 3. Verify fetchCurrentUser was called
        XCTAssertTrue(mockCurrentUserService.fetchCurrentUserCalled)

        // 4. Verify errorMessage is set
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, fetchError.localizedDescription)
    }
    
    func test_signOut_success() {
        
        sut.userSession = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockCurrentUserService.currentUser = User(id: testUserID,
                                                  fullname: "Test",
                                                  username: "test",
                                                  email: "test",
                                                  isDelete: false)
        mockFirebaseStaticAuthProvider.signOutShouldThrow = nil
        
        sut.signOut()
        
        // 1. Verify currentUser in CurrentUserService is nil
        XCTAssertNil(mockCurrentUserService.currentUser)

        // 2. Verify signOut was called on the static provider
        XCTAssertTrue(mockFirebaseStaticAuthProvider.signOutCalled)

        // 3. Verify userSession is nil
        XCTAssertNil(sut.userSession)
    }
    
    func test_signOut_failure_signOutThrows() {
        sut.userSession = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockCurrentUserService.currentUser = User(id: testUserID,
                                                  fullname: "Test",
                                                  username: "test",
                                                  email: "test",
                                                  isDelete: false)
        let signOutError = NSError(domain: "AuthErrorDomain",
                                   code: 100,
                                   userInfo: [NSLocalizedDescriptionKey: "Sign out failed."])
        mockFirebaseStaticAuthProvider.signOutShouldThrow = signOutError
        
        sut.signOut()
        
        // 1. Verify currentUser in CurrentUserService is nil
        XCTAssertNil(mockCurrentUserService.currentUser)

        // 2. Verify signOut was called on the static provider
        XCTAssertTrue(mockFirebaseStaticAuthProvider.signOutCalled)

        // 3. Verify userSession is nil (AuthService clears it regardless of signOut success)
        XCTAssertNil(sut.userSession)
    }
    
    func test_checkUserSession_success_userExists() async throws {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockFirebaseStaticAuthProvider.currentUserResult = mockUser
        mockUser.idTokenForcingRefreshResult = "new_token"
        mockCurrentUserService.fetchCurrentUserShouldThrow = nil
        
        await sut.checkUserSession()
        
        // 1. Verify userSession is set
        XCTAssertNotNil(sut.userSession)
        XCTAssertEqual(sut.userSession?.uid, testUserID)

        // 2. Verify idTokenForcingRefresh was called
        XCTAssertTrue(mockUser.idTokenForcingRefreshCalled)

        // 3. Verify fetchCurrentUser was called
        XCTAssertTrue(mockCurrentUserService.fetchCurrentUserCalled)
        XCTAssertEqual(mockCurrentUserService.capturedFetchUserID, testUserID)

        // 4. Verify errorMessage is nil
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_checkUserSession_failure_noCurrentUser() async {
        
        mockFirebaseStaticAuthProvider.currentUserResult = nil
        
        await sut.checkUserSession()
        
        // 1. Verify userSession is nil
        XCTAssertNil(sut.userSession)

        // 2. Verify errorMessage is nil
        XCTAssertNil(sut.errorMessage)

        // 3. Verify idTokenForcingRefresh was NOT called
        XCTAssertFalse(mockCurrentUserService.fetchCurrentUserCalled,
                       "fetchCurrentUser should not be called if no current user.")
        
    }
    
    func test_checkUserSession_failure_tokenRefreshFails() async {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockFirebaseStaticAuthProvider.currentUserResult = mockUser
        let tokenRefreshError = NSError(domain: "AuthErrorDomain",
                                        code: AuthErrorCode.networkError.rawValue,
                                        userInfo: [NSLocalizedDescriptionKey: "Network error during token refresh."])
        mockUser.idTokenForcingRefreshShouldThrow = tokenRefreshError
        
        await sut.checkUserSession()
        
        // 1. Verify userSession is nil (cleared on error)
        XCTAssertNil(sut.userSession)

        // 2. Verify errorMessage is set
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, tokenRefreshError.localizedDescription)

        // 3. Verify idTokenForcingRefresh was called
        XCTAssertTrue(mockUser.idTokenForcingRefreshCalled)

        // 4. Verify fetchCurrentUser was NOT called
        XCTAssertFalse(mockCurrentUserService.fetchCurrentUserCalled, "fetchCurrentUser should not be called if token refresh fails.")
    }
    
    func test_checkUserSession_failure_fetchCurrentUserFails() async {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        mockFirebaseStaticAuthProvider.currentUserResult = mockUser
        mockUser.idTokenForcingRefreshShouldThrow = nil
        
        let fetchError = NSError(domain: "FirestoreErrorDomain",
                                 code: 1,
                                 userInfo: [NSLocalizedDescriptionKey: "User document not found."])
        mockCurrentUserService.fetchCurrentUserShouldThrow = fetchError
        
        await sut.checkUserSession()
        
        // 1. Verify userSession is nil (cleared on error)
        XCTAssertNil(sut.userSession)

        // 2. Verify errorMessage is set
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.errorMessage, fetchError.localizedDescription)

        // 3. Verify idTokenForcingRefresh was called
        XCTAssertTrue(mockUser.idTokenForcingRefreshCalled)

        // 4. Verify fetchCurrentUser was called
        XCTAssertTrue(mockCurrentUserService.fetchCurrentUserCalled)
        XCTAssertEqual(mockCurrentUserService.capturedFetchUserID, testUserID)
    }
}
