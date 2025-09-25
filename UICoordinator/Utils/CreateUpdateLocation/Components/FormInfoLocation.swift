//
//  FormInfoLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI

struct FormInfoLocation: View {
    
    @Binding var name: String
    @Binding var description: String
    @Binding var address: String
    
    var body: some View {
        VStack {
            
            TextField(
                "",
                text: $name,
                prompt: Text("Place name")
                    .foregroundStyle(.gray)
            )
                .font(.body)
                .padding(9)
                .foregroundStyle(Color.black)
                .modifier(CornerRadiusModifier())
            
            TextField(
                "",
                text: $address,
                prompt: Text("Address...")
                    .foregroundStyle(.gray),
                axis: .vertical
            )
                .font(.callout)
                .padding(8)
                .foregroundStyle(Color.black)
                .modifier(CornerRadiusModifier())
            
            TextField(
                "",
                text: $description,
                prompt: Text("Description...")
                    .foregroundStyle(.gray),
                axis: .vertical
            )
                .font(.callout)
                .padding(8)
                .foregroundStyle(Color.black)
                .modifier(CornerRadiusModifier())
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    FormInfoLocation(name: .constant(""), description: .constant(""), address: .constant(""))
}
