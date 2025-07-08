//
//  UserError.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import Foundation

enum UserError: Error, LocalizedError {
    
    case invalidType
    case userNotFound
    case userIdNil
    case usernameAlreadyTaken
    case authCreationFailed(Error)
    case firestoreUploadFailed(Error)
    case unknownError(Error)
    case userCreateNil
    case imageTooLarge(currentSizeMB: Double, maxSizeMB: Double)
    case imageUploadFailed
    case imageUploadError(Error)
    case usernameTakenDuringRegistration
    case generalError(String)
    case firestoreServiceError(Error)
    
    var description: String {
        switch self {
        case .invalidType:
            return "Invalide type"
        case .userNotFound:
            return "Current user not found"
        case .userIdNil:
            return "Current user id is nil"
        case .usernameAlreadyTaken:
            return "This username is already taken. Please choose another one."
        case .authCreationFailed(let error):
            return "Failed to create account: \(error.localizedDescription)"
        case .firestoreUploadFailed(let error):
            return "Failed to save user data: \(error.localizedDescription)"
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        case .userCreateNil:
            return "User is not created"
        case .imageTooLarge(let current, let max):
            return "The image size (\(String(format: "%.2f", current)) MB) exceeds the maximum allowed (\(String(format: "%.2f", max)) MB)."
        case .imageUploadFailed:
            return "Failed to upload profile image. Please try again later."
        case .imageUploadError(let error):
            return "Failed to save image to storage: \(error.localizedDescription)"
        case .usernameTakenDuringRegistration:
            return "Username was taken during registration. Please try again."
        case .generalError(let stringError):
            return stringError
        case .firestoreServiceError(let error):
            return "Firestore service error: \(error.localizedDescription)"
        }
    }
}
