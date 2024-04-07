//
//  ContentView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                CoordinatorTabView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
