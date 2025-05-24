//
//  WikipediaAttributionView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/05/2025.
//

import SwiftUI

struct WikipediaAttributionView: View {
    
    var body: some View {
        VStack {
            
            Text("Content provided by")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Link("Wikipedia (CC BY-SA 4.0)", destination: URL(string: "https://creativecommons.org/licenses/by-sa/4.0/")!)
                .font(.footnote)
                .foregroundStyle(.blue)
            
            Text("Wikipedia® is a trademark of the Wikimedia Foundation.")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    WikipediaAttributionView()
}
