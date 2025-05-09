//
//  LocalUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Foundation
import SwiftData

@Model
class LocalUser {
    @Attribute(.unique) var id: String
    var fullname: String
    @Attribute(.unique) var username: String
    var email: String
    var profileImageURL: String?
    var bio: String?
    var link: String?
    var isDelete: Bool
    var isPrivateProfile: Bool?
    
    init(id: String, fullname: String, username: String, email: String, profileImageURL: String? = nil, bio: String? = nil, link: String? = nil, isDelete: Bool = false, isPrivateProfile: Bool? = nil) {
        self.id = id
        self.fullname = fullname
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.link = link
        self.isDelete = isDelete
        self.isPrivateProfile = isPrivateProfile
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
