//
//  UserLocationsViewModelFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2025.
//

import Foundation

struct UserLocationsViewModelFactory {
    
    static func makeViewModel(userId: String) -> UserLocationsViewModel {
        UserLocationsViewModel(userId: userId,
                               fetchLocationsService: FetchLocationsFromFirebase())
    }
}
