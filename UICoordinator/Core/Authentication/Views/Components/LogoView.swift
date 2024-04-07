//
//  LogoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("appstore")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .padding()
    }
}

#Preview {
    LogoView()
}
