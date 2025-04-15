//
//  ProfileImageSize.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 27/02/2024.
//

import Foundation

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall:
            return 28
        case .xSmall:
            return 32
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 64
        case .xLarge:
            return 80
        case .xxLarge:
            return 128
        }
    }
}
