//
//  FetchingFollowAndFollowCountProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

protocol FetchingFollowAndFollowCountProtocol {
    
    func fetchFollow(uid: String, byField: FieldToFetching) async -> [Follow]
    
    func fetchFollowCount(uid: String, byField: FieldToFetching) async -> Int
}
