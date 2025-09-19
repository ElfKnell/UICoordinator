//
//  ModerationError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/09/2025.
//

import Foundation

enum ModerationError: Error, LocalizedError {
    
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case jsonDecodingFailed(Error)
    case invalidPost
    case invalidImage
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for the API request."
        case .requestFailed(let error):
            return "The request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Incorrect response format from the server."
        case .jsonDecodingFailed(let error):
            return "JSON decoding error: \(error.localizedDescription)"
        case .invalidPost:
            return "Your message contains unacceptable language for the app, so it cannot be published."
        case .invalidImage:
            return "Your photo contains unacceptable content and cannot be published in the app."
        }
    }
}
