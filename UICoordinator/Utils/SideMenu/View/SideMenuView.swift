//
//  SideMenuView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowind: Bool
    @Binding var selectedTab: Int
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    @State private var selectedOption: OptionModel?
    
    let widthSideMenu = UIScreen.main.bounds.width / 3 * 2
    private var user: User {
        return viewModel.currentUser ?? DeveloperPreview.user
    }
    
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
                        
                        SideMenuHeaderView()
                        
                        Divider()
                        
                        VStack {
                            ForEach(OptionModel.allCases) { option in
                                Button {
                                    selectedOption = option
                                    selectedTab = option.rawValue
                                    isShowind.toggle()
                                } label: {
                                    SideMenuRowView(selected: $selectedOption, option: option)
                                }

                            }
                        }
                        
                        Divider()
                        
                        BottomSideMenu(widthButton: widthSideMenu - 32)
                        
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
    SideMenuView(isShowind: .constant(true), selectedTab: .constant(0))
}
