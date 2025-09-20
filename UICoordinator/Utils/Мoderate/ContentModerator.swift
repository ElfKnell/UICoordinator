//
//  ContentModerator.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/09/2025.
//

import Foundation
import Alamofire
import FirebaseFunctions
import SwiftUI

class ContentModerator: ContentModeratorProtocol {
    
    private let functions = Functions.functions()
    
    func moderateText(text: String) async throws -> Bool {
        
        let result = try await functions
            .httpsCallable("moderateText").call(["text": text])
        
        guard let data = result.data as? [String: Any],
              let flagged = data["flagged"] as? Bool else {

            throw NSError(
                domain: "ModerationService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid data format"]
            )
        }
        
        return flagged
        
    }

    func checkImage(image: UIImage) async throws -> Bool {
        
        guard let resizedImage = image.resized(to: 512),
              let imageData = resizedImage.jpegData(compressionQuality: 0.2) else {
            throw NSError(
                domain: "NSFWService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
        }
        
        let base64String = imageData.base64EncodedString()
        
        let result = try await functions
            .httpsCallable("moderateImage").call(["image": base64String])
        
        guard let data = result.data as? [String: Any],
              let flagged = data["flagged"] as? Bool else {
            
            throw NSError(
                domain: "ModerationService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid data format"]
            )
        }
        
        return flagged
        
    }
}
