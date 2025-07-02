//
//  ImageUploaderProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/07/2025.
//

import Foundation
import Firebase
import FirebaseStorage

protocol ImageUploaderProtocol {
    
    func uploadeImage(_ image: UIImage, currentUser: User) async throws -> String?
    
    func deleteImage(currentUser: User)  async throws
    
}
