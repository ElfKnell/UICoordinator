//
//  ButtonBoolView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/08/2024.
//

import SwiftUI

struct ButtonBoolView: View {
    
    var imageName: String
    @Binding var isCheck: Bool
    
    var body: some View {
        
        Button {
            isCheck.toggle()
        } label: {
            Image(systemName: imageName)
                .imageScale(.large)
        }
        .foregroundStyle(isCheck ? .white : .black)
        .padding(5)
        .background(.green .opacity(isCheck ? 1 : 0))
        .clipShape(.circle)
        .padding(5)
        
    }
}

#Preview {
    ButtonBoolView(imageName: "", isCheck: .constant(false))
}
