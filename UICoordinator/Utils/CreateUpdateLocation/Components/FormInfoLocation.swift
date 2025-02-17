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
            
            TextField("Place name", text: $name)
                .font(.callout)
                .padding(9)
                .modifier(CornerRadiusModifier())
            
            TextField("Address...", text: $address, axis: .vertical)
                .font(.footnote)
                .padding(8)
                .modifier(CornerRadiusModifier())
            
            TextField("Description...", text: $description, axis: .vertical)
                .font(.footnote)
                .padding(8)
                .modifier(CornerRadiusModifier())
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    FormInfoLocation(name: .constant(""), description: .constant(""), address: .constant(""))
}
