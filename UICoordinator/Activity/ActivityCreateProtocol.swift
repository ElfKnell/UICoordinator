//
//  ActivityCreateProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/05/2025.
//

import Foundation

protocol ActivityCreateProtocol {
    func uploadedActivity(_ activity: Activity) async throws
}
