//
//  FirestoreFollowServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

protocol FirestoreFollowServiceProtocol {
    
    func getFollows(uid: String, followField: FieldToFetching) async throws -> [Follow]
    func getFollowCount(uid: String, followField: FieldToFetching) async throws -> Int
    
}
