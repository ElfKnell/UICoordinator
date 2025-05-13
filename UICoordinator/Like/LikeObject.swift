//
//  LikeObject.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/05/2025.
//

import Foundation

protocol LikeObject: Identifiable {
    
    var ownerUid: String { get }
    var likes: Int { get }
}
