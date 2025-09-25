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
        let rgba = self.toRGB()
        let string = "\(rgba.red),\(rgba.green),\(rgba.blue),\(rgba.alpha)"
        
        // Save the RGBA string to AppStorage
        UserDefaults.standard.set(string, forKey: keyColor)
    }
    
    static func loadFromAppStorage(_ nameColor: String) -> Color? {
        
        guard let rgbaString = UserDefaults.standard.string(forKey: nameColor) else {
                return nil
        }
            
        // Split the RGBA string and convert to CGFloat values
        let components = rgbaString.split(separator: ",").compactMap { CGFloat(Double($0) ?? 0.0) }
        
        guard components.count == 4 else { return nil }
        return Color(red: components[0], green: components[1], blue: components[2], opacity: components[3])
        
    }
    
}
