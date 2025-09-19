//
//  BlockServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation

protocol BlockServiceProtocol {
    
    func uploadeBlock(curentUserIs: String, userId: String) async throws
    func deleteBlock(curentUserIs: String, userId: String) async throws
    
}
