//
//  ContentModeratorProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/09/2025.
//

import Foundation
import SwiftUI

protocol ContentModeratorProtocol {
    
    func analyzeTextWithAlamofire(input: String, model: AIModels) async throws -> SentimentPrediction
    
    func check(image: UIImage) async throws -> [SentimentPrediction]
    
}
