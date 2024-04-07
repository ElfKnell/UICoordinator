//
//  BottomSideMenu.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct BottomSideMenu: View {
    let widthButton: CGFloat
    
    var body: some View {
        VStack {
            
            Button {
                AuthService.shared.signOut()
            } label: {
                Label("Log Out", systemImage: "lock.shield.fill")
                    .foregroundStyle(.red)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: widthButton, height: 44)
                    .background(.white)
                    .modifier(CornerRadiusModifier())
                    .padding(.bottom)
            }

            Button {
                
            } label: {
                Label("Delete", systemImage: "trash.fill")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: widthButton, height: 44)
                    .background(.red)
                    .modifier(CornerRadiusModifier())
            }
        }
    }
}

#Preview {
    BottomSideMenu(widthButton: 250)
}
