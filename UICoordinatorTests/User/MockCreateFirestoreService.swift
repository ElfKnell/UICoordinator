//
//  MockCreateFirestoreService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Testing

class MockCreateFirestoreService: FirestoreCreateUserProtocol {

    var receivedData: [String: Any]?
    var receivedId: String?
    var didCallSetData = false

    func setUserData(id: String, data: [String : Any]) async throws {
        receivedId = id
        receivedData = data
        didCallSetData = true
    }

}
