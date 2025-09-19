//
//  PhotoServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/06/2025.
//

import Foundation
import UIKit

protocol PhotoServiceProtocol {
    
    func fetchPhotosByLocation(_ locationId: String) async throws -> [Photo]
    
    func updateNamePhoto(photoId: String, photoName: String) async throws
    
    func deletePhoto(photo: Photo)  async throws
    
    func deletePhotoByLocation(_ locationId: String) async throws
    
}
