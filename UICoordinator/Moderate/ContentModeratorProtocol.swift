//
//  ContentModeratorProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/09/2025.
//

import Foundation
import SwiftUI

protocol ContentModeratorProtocol {
    
    //func analyzeTextWithAlamofire(input: String, model: AIModels) async throws -> SentimentPrediction
    
    func moderateText(text: String) async throws -> Bool
    
    func checkImage(image: UIImage) async throws -> Bool
    
}
