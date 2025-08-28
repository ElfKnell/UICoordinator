//
//  LikeObject.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/05/2025.
//

import Foundation

protocol LikeObject: Identifiable {
    
    var id: String { get }
    var ownerUid: String { get }
    var likes: Int { get }
    var repliesCount: Int? { get }
    
}
