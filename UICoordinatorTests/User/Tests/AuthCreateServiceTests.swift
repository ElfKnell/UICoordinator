//
//  AuthCreateServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import XCTest
import Firebase
import FirebaseAuth

final class AuthCreateServiceTests: XCTestCase {

    var mockCreateUserService: MockCreateUserService!
    var mockAuthService: MockAuth!
    var sut: AuthCreateService!
    
    let testUserID = "mock_user_uid_123"
    let testEmail = "test@example.com"
    let testPassword = "password123"
    let testFullname = "User Test"
    let testUsername = "etestname"
    
    override func setUp() {
        super.setUp()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        mockCreateUserService = MockCreateUserService()
        mockAuthService = MockAuth()
        sut = AuthCreateService(createUserService: mockCreateUserService,
                                authService: mockAuthService)
    }
    
    override func tearDown() {
        sut = nil
        mockCreateUserService = nil
        mockAuthService = nil
        super.tearDown()
    }

    func test_createUser_success_withEmailFromAuthResult() async throws {
        
        let authResultEmail = "auth_result@example.com"
        let mockUser = MockFirebaseUser(uid: testUserID, email: authResultEmail)
        let mockAuthResult = MockAuthDataResult(firebaseUser: mockUser)
        mockAuthService.createUserResult = mockAuthResult
        
        try await sut.createUser(withEmail: testEmail,
                                 password: testPassword,
                                 fullname: testFullname,
                                 username: testUsername)
        
        XCTAssertTrue(mockAuthService.createUserCalled)
        XCTAssertEqual(mockAuthService.capturedEmail, testEmail)
        
        XCTAssertTrue(mockCreateUserService.uploadUserDataCalled)
        XCTAssertEqual(mockCreateUserService.capturedUserID, testUserID)
        XCTAssertEqual(mockCreateUserService.capturedEmail, authResultEmail, "Email passed to uploadUserData should be from AuthResult.")
        XCTAssertEqual(mockCreateUserService.capturedFullname, testFullname)
        XCTAssertEqual(mockCreateUserService.capturedUsername, testUsername)
        
        XCTAssertFalse(mockUser.deleteCalled)
    }
    
    func test_createUser_success_withEmailFallbackFromParameter() async throws {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: nil)
        let mockAuthResult = MockAuthDataResult(firebaseUser: mockUser)
        mockAuthService.createUserResult = mockAuthResult
        
        try await sut.createUser(withEmail: testEmail,
                                 password: testPassword,
                                 fullname: testFullname,
                                 username: testUsername)
        
        XCTAssertTrue(mockAuthService.createUserCalled)
        
        XCTAssertTrue(mockCreateUserService.uploadUserDataCalled)
        XCTAssertEqual(mockCreateUserService.capturedUserID, testUserID)
        XCTAssertEqual(mockCreateUserService.capturedEmail, testEmail, "Email passed to uploadUserData should be from AuthResult.")
        XCTAssertEqual(mockCreateUserService.capturedFullname, testFullname)
        XCTAssertEqual(mockCreateUserService.capturedUsername, testUsername)
        
        XCTAssertFalse(mockUser.deleteCalled)
    }
    
    func test_createUser_failure_authCreationFails() async {
        
        let authError = NSError(domain: AuthErrorDomain,
                                code: AuthErrorCode.emailAlreadyInUse.rawValue,
                                userInfo: [NSLocalizedDescriptionKey: "Email already in use."])
        mockAuthService.createUserShouldThrowError = authError
        
        do {
            try await sut.createUser(withEmail: testEmail,
                                     password: testPassword,
                                     fullname: testFullname,
                                     username: testUsername)
            XCTFail("Expected authCreationFailed error, but call succeeded.")
        } catch let caughtError as UserError {
            
            if case .authCreationFailed(let underlyingError) = caughtError {
                XCTAssertEqual((underlyingError as NSError).domain, authError.domain)
                XCTAssertEqual((underlyingError as NSError).code, authError.code)
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
    }
    
    func test_createUser_failure_uploadUserDataFails_userDeleted() async {
        
        let mockUser = MockFirebaseUser(uid: testUserID, email: testEmail)
        let mockAuthResult = MockAuthDataResult(firebaseUser: mockUser)
        mockAuthService.createUserResult = mockAuthResult
        
        let uploadError = NSError(domain: "FirestoreErrorDomain",
                                code: 101,
                                userInfo: [NSLocalizedDescriptionKey: "Firestore upload failed."])
        mockCreateUserService.shouldThrowError = uploadError
        
        do {
            try await sut.createUser(withEmail: testEmail,
                                     password: testPassword,
                                     fullname: testFullname,
                                     username: testUsername)
            XCTFail("Expected an error to be thrown (unknownError from upload failure), but call succeeded.")
        } catch let caughtError as UserError {
            
            if case .unknownError(let underlyingError) = caughtError {
                XCTAssertEqual((underlyingError as NSError).domain, uploadError.domain)
                XCTAssertEqual((underlyingError as NSError).code, uploadError.code)
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockAuthService.createUserCalled)
        XCTAssertTrue(mockCreateUserService.uploadUserDataCalled)
        XCTAssertTrue(mockUser.deleteCalled, "User.delete() should have been called to clean up Auth user.")
    }
    
    func test_createUser_failure_authResultIsNil() async {
        
        mockAuthService.createUserResult = nil
        
        do {
            try await sut.createUser(withEmail: testEmail,
                                     password: testPassword,
                                     fullname: testFullname,
                                     username: testUsername)
            XCTFail("Expected userCreateNil error, but call succeeded.")
            
        } catch let caughtError as UserError {
            
            if case .unknownError(let underlyingError) = caughtError {
                let nsError = underlyingError as NSError
                XCTAssertEqual(nsError.domain, "MockAuthError")
                XCTAssertEqual(nsError.code, 0)
                XCTAssertEqual(nsError.localizedDescription, "Mock createUserResult not set")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertFalse(mockCreateUserService.uploadUserDataCalled)
    }
}
