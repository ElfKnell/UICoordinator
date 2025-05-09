//
//  ColloquyServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/05/2025.
//

import Foundation

protocol ColloquyServiceProtocol {
    
    func uploadeColloquy(_ colloquy: Colloquy) async
    
    func markForDelete(_ colloquyId: String) async
    
    func unmarkForDelete(_ colloquyId: String) async
    
    func deleteColloquy(_ colloquy: Colloquy) async
    
}
