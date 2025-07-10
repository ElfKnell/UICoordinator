//
//  CollectionReferenceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation

protocol CollectionReferenceProtocol {
    
    func document(_ documentPath: String) -> DocumentReferenceProtocol
}
