//
//  UserServiceUpdateTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import XCTest

final class UserServiceUpdateTests: XCTestCase {

    func testUpdateUserProfile_sendsCorrectData() async throws {

        let firestore = MockFirestore()
        let sut = UserServiceUpdate(firestore: firestore)

        await sut.updateUserProfile(userId: "user_1256", nickname: "John", bio: "iOS Dev", link: "https://john.dev")

        let updated = firestore.mockCollection.mockDocument.updatedData
        XCTAssertEqual(updated?["username"] as? String, "John")
        XCTAssertEqual(updated?["bio"] as? String, "iOS Dev")
        XCTAssertEqual(updated?["link"] as? String, "https://john.dev")
    }

    func testUpdateUserProfileImage_sendsCorrectData() async throws {

        let firestore = MockFirestore()
        let sut = UserServiceUpdate(firestore: firestore)

        await sut.updateUserProfileImage(withImageURL: "https://image.dev/photo.jpg", userId: "user_id1325")

        let updated = firestore.mockCollection.mockDocument.updatedData
        XCTAssertEqual(updated?["profileImageURL"] as? String, "https://image.dev/photo.jpg")
    }
    
    func testDeleteUserProfile_sendsCorrectData() async throws {

        let firestore = MockFirestore()
        let sut = UserServiceUpdate(firestore: firestore)

        await sut.deleteUser(userId: "user_1256")

        let updated = firestore.mockCollection.mockDocument.updatedData
        XCTAssertEqual(updated?["isDelete"] as? Bool, true)
    }
}
