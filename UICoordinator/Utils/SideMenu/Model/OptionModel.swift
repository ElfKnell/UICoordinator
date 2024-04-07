//
//  OptionModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import Foundation

enum OptionModel: Int, CaseIterable, Identifiable {
    case profile
    case notifications
    case settings
    case help
    case about
    
    var title: String {
        switch self {
        case .profile:
            "Profile"
        case .notifications:
            "Notifications"
        case .settings:
            "Settings"
        case .help:
            "Help"
        case .about:
            "About"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .profile:
            "person.crop.circle.badge.checkmark"
        case .notifications:
            "bell"
        case .settings:
            "gearshape"
        case .help:
            "questionmark.diamond"
        case .about:
            "exclamationmark.shield"
        }
    }
    
    var id: Int {
        self.rawValue
    }
}
