//
//  KingfisherPhoto.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/09/2025.
//

import SwiftUI
import Kingfisher

struct KingfisherPhoto: View {
    
    let photoURL: String
    
    var body: some View {
        KFImage(URL(string: photoURL))
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
            .shadow(radius: 2)
    }
}

#Preview {
    KingfisherPhoto(photoURL: "")
}
