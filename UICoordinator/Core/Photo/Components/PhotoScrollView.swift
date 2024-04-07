//
//  PhotoScrollView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI
import Kingfisher

struct PhotoScrollView: View {
    
    let photos: [Photo]
    
    @Binding var bphoto: Photo?
    @Binding var switcher: PhotoSwitch
    @Binding var namePhoto: String
    
    @State private var currentOrientation = UIDevice.current.orientation
    @State private var height = 0.0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(photos) { photo in
                    VStack {
                        KFImage(URL(string: photo.photoURL))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        
                        Text(photo.name ?? "")
                            .foregroundStyle(.black)
                    }
                    .padding(3)
                    .onTapGesture {
                        bphoto = photo
                        switcher = .oldPhoto
                        namePhoto = photo.name ?? ""
                    }
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal)
        .onAppear {
            height = UIScreen.main.bounds.height * 0.2
        }
        .onChange(of: currentOrientation) {
            height = UIScreen.main.bounds.height * 0.2
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        self.currentOrientation = UIDevice.current.orientation
                    }
    }
}

#Preview {
    PhotoScrollView(photos: [Photo](), bphoto: .constant(DeveloperPreview.photo), switcher: .constant(.oldPhoto), namePhoto: .constant(""))
}
