//
//  AIModels.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/09/2025.
//

import Foundation

enum AIModels {
    case analyzeText
    
    var value: String {
        switch self {
        case .analyzeText:
            return "tabularisai/multilingual-sentiment-analysis"
        }
    }
}
