//
//  PhotoUploadToFirebaseProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2025.
//

import Foundation
import UIKit

protocol PhotoUploadToFirebaseProtocol {
    
    func uploadePhotoStorage(_ photo: UIImage, locationId: String, namePhoto: String) async throws
    
}
