//
//  UserServiceUpdateProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation

protocol UserServiceUpdateProtocol {
    
    func updateUserProfile(userId: String, nickname: String, bio: String, link: String) async
    
    func updateUserProfileImage(withImageURL imageURL: String, userId: String) async
    
    func deleteUser(userId: String?) async
    
    func updateUserPrivate(isPrivateProfile: Bool, userId: String) async
    
}
