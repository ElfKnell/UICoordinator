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
    
    private let apiKey = ""
    private let startpoint = "https://api-inference.huggingface.co/models/"
    
    func analyzeTextWithAlamofire(input: String, model: AIModels) async throws -> SentimentPrediction {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.apiKey)",
            "Content-Type": "application/json"
        ]
            
        let parameters: [String: Any] = ["inputs": input]
            
        let url = "https://api-inference.huggingface.co/models/\(model.value)"
            
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .serializingDecodable([[SentimentPrediction]].self)
            .response
            
        switch response.result {
        case .success(let value):
            guard let result = value.first?.first else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            return result
        case .failure(let error):
            throw error
        }
    }
    
    func check(image: UIImage) async throws -> [SentimentPrediction] {
        
        guard let resizedImage = image.resized(to: 512),
              let imageData = resizedImage.jpegData(compressionQuality: 0.2) else {
            throw NSError(
                domain: "NSFWService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
        }
        
        let url = "\(startpoint)Falconsai/nsfw_image_detection"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.apiKey)",
            "Content-Type": "image/jpeg"
        ]
            
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                imageData,
                to: url,
                method: .post,
                headers: headers
            )
            .validate()
            .responseDecodable(of: [SentimentPrediction].self) { response in
                switch response.result {
                case .success(let results):
                    continuation.resume(returning: results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
