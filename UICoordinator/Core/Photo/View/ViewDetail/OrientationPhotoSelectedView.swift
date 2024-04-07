//
//  OrientationPhotoSelectedView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/03/2024.
//

import SwiftUI

struct OrientationPhotoSelectedView: View {
    
    @EnvironmentObject var viewModel: PhotoViewModel
    @State private var currentOrientation = UIDevice.current.orientation
    @State private var isUserPortrait = true

    var body: some View {
        
        VStack {
            if isUserPortrait {
                VHeaderPhotoSelected
                
                VStack {
                    BodyPhotoSelected
                }
            } else {
                HHeaderPhotoSelected
                
                HStack {
                    BodyPhotoSelected
                }
            }
            
            Spacer()
        }
        .onAppear {
            isUserPortrait = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? true : false
        }
        .onChange(of: currentOrientation) {
            isUserPortrait = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? true : false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        self.currentOrientation = UIDevice.current.orientation
                    }
    }
}

#Preview {
    OrientationPhotoSelectedView()
}
