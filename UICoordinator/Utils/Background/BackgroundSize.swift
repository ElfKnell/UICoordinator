//
//  BackgroundSize.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/05/2025.
//

import SwiftUI
import Foundation

enum BackgroundSize {
    case normal
    case large
    
    var value: CGFloat {
        switch self {
        case .normal:
            return UIScreen.main.bounds.height
        case .large:
            return UIScreen.main.bounds.height * 1.3
        }
    }
}
