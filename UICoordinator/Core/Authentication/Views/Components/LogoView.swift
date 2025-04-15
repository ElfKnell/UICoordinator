//
//  LogoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct LogoView: View {
    
    private var sizeLogo: ProfileImageSize {
        let device = UIDevice.current.name
        if device.contains("SE") || device.contains("mini") {
            return .large
        } else if device.contains("iPhone") {
            return .xLarge
        } else {
            return .xxLarge
        }
    }
    
    var body: some View {
        
        Image("appstore")
            .resizable()
            .scaledToFit()
            .frame(width: sizeLogo.dimension, height: sizeLogo.dimension)
            .clipShape(Circle())
            .padding()
    }

}

#Preview {
    LogoView()
}
