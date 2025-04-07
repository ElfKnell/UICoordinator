//
//  ExtensionColor.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/03/2025.
//

import Foundation
import SwiftUI

extension Color {
    // Convert Color to RGB components
    func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        // Convert the Color to a UIColor first
        let uiColor = UIColor(self)
        
        // Get the RGBA components from UIColor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    // Save RGBA components to AppStorage
    func saveToAppStorage(_ keyColor: String) {
        let (red, green, blue, alpha) = self.toRGB()
        let rgbaString = "\(red),\(green),\(blue),\(alpha)"
        
        // Save the RGBA string to AppStorage
        UserDefaults.standard.set(rgbaString, forKey: keyColor)
    }
    
    static func loadFromAppStorage(_ nameColor: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
            guard let rgbaString = UserDefaults.standard.string(forKey: nameColor) else {
                return nil
        }
            
        // Split the RGBA string and convert to CGFloat values
        let components = rgbaString.split(separator: ",").compactMap { CGFloat(Double($0) ?? 0.0) }
        if components.count == 4 {
            return (components[0], components[1], components[2], components[3])
        }
        
        return nil
    }
    
}
