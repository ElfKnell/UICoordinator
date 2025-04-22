//
//  FirestoreProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation

protocol FirestoreProtocol {
    func collection(_ path: String) -> FirestoreCollectionProtocol
}
