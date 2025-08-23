//
//  CustomImage.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import Foundation
import UIKit
import MapKit

class CustomImage {
    
    static func generateCustomRouteImage(
        number: Int,
        transportType: MKDirectionsTransportType?) -> UIImage? {
        
        let baseSize = CGSize(width: 30, height: 30)
        
        var baseImage = UIImage(systemName: "car")
            
        if let transportType = transportType {
            switch transportType.self {
            case .walking:
                baseImage = UIImage(systemName: "figure.walk")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .transit:
                baseImage = UIImage(systemName: "bus.fill")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .automobile:
                baseImage = UIImage(systemName: "car")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            case .any:
                baseImage = UIImage(systemName: "questionmark.circle")?
                    .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(baseSize, false, 0)
        baseImage?.draw(in: CGRect(origin: .zero, size: baseSize))
        
        let text = "\(number)"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 27),
            .foregroundColor: UIColor.systemRed,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(x: 0, y: 0, width: baseSize.width, height: baseSize.height)
        text.draw(in: textRect, withAttributes: attrs)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}
