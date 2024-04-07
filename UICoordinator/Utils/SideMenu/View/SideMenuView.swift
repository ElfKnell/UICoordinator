//
//  SideMenuView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowind: Bool
    let user: User
    let widthSideMenu = UIScreen.main.bounds.width / 3 * 2
    
    var body: some View {
        ZStack {
            if isShowind {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowind.toggle()
                    }
                
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 32) {
                        
                        SideMenuHeaderView(user: user)
                        
                        BodySideMenu(widthButton: widthSideMenu - 32)
                        
                        Spacer()
                        
                    }
                    .padding()
                    .frame(width: widthSideMenu, alignment: .leading)
                    .background()
                }
                .transition(.move(edge: .trailing))
            }
        }
        
        .animation(.easeInOut, value: isShowind)
    }
}

#Preview {
    SideMenuView(isShowind: .constant(true), user: DeveloperPreview.user)
}
