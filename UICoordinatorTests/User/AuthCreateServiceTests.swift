//
//  AuthCreateServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 02/05/2025.
//

import XCTest

final class AuthCreateServiceTests: XCTestCase {

    func testCreateNewUserService() async {
        let mockCreateUser = MockCreateUserService()
        
        let authCreateService = AuthCreateService(
            createUserService: mockCreateUser
        )
        
        let email = "test@test.com"
        let fullname = "Van Gog"
        let username = "vangog"
        let password = "123456"
        
        let isSave = await authCreateService.createUser(withEmail: email, password: password, fullname: fullname, username: username)
        
        XCTAssertTrue(isSave)
        XCTAssertNil(authCreateService.errorMessage)
        XCTAssertTrue(mockCreateUser.uploaded)
    }

}
