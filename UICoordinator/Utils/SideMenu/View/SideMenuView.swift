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
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @State private var selectedOption: OptionModel?
    
    let widthSideMenu = UIScreen.main.bounds.width / 3
    
    var body: some View {
        ZStack {
            if isShowind {
                Rectangle()
                    .opacity(0.3)
                    .onTapGesture {
                        isShowind.toggle()
                    }
                
                HStack {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 32) {
                        
                        ScrollView {
                            SideMenuHeaderView()
                            
                            Divider()
                                .padding()
                            
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
                                .padding()
                            
                            BottomSideMenu(widthButton: (isLandscape ? widthSideMenu : widthSideMenu * 2) - 32)
                            
                        }
                        
                    }
                    .padding()
                    .frame(width: isLandscape ? widthSideMenu : widthSideMenu * 2, alignment: .leading)
                    .background()
                }
                .transition(.move(edge: .trailing))
            }
        }
        
        .animation(.easeInOut, value: isShowind)
        .onAppear {
            
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                isLandscape = UIDevice.current.orientation.isLandscape
            }
            
            for option in OptionModel.allCases {
                if option.rawValue == selectedTab {
                    selectedOption = option
                }
            }
        }
    }
}

#Preview {
    SideMenuView(isShowind: .constant(true), selectedTab: .constant(0))
}
