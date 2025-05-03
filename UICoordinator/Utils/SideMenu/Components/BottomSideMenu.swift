//
//  BottomSideMenu.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct BottomSideMenu: View {
    
    let widthButton: CGFloat
    @State private var isLoggedOut = false
    @EnvironmentObject var container: DIContainer
    var userServise = UserService()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button {
                    Task {
                        await container.userFollow.clearLocalUsers()
                        container.authService.signOut()
                    }
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
                
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                LoginView()
            }
        }
    }
}

#Preview {
    BottomSideMenu(widthButton: 250)
}
