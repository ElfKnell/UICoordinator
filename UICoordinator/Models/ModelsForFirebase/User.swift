//
//  User.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Foundation

struct User: Identifiable, Codable, Hashable, Equatable {
    
    let id: String
    let fullname: String
    let username: String
    let email: String
    var profileImageURL: String?
    var bio: String?
    var link: String?
    var isDelete: Bool
    var isPrivateProfile: Bool?
    
    var initials: String {
        
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
