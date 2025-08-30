//
//  ColloquyServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/05/2025.
//

import Foundation

protocol ColloquyServiceProtocol {
    
    func uploadeColloquy(_ colloquy: Colloquy) async throws
    
    func deleteColloquy(_ colloquy: any LikeObject) async throws
    
}
