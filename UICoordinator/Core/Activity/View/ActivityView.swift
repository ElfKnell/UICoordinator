//
//  ActivityView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI
import MapKit
import Firebase

struct ActivityView: View {

    @StateObject var viewModel = ActivityViewModel()
    @State private var isCreate = false
    @State var name = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {

            ScrollView {
                
                ActivityContentListView()
                
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self, destination: { name in
                ActivityCreate(nameActivyty: name)
            })
            .toolbar {
                Button {
                    isCreate.toggle()
                } label: {
                    Image(systemName: "pencil.tip.crop.circle.badge.plus")
                        .font(.title2)
                }
                .alert("Create a new activity", isPresented: $isCreate) {
                    
                    TextField("Name activity", text: $name)
                    
                    Button("OK") {
                        if !name.isEmpty {
                            path.append(name)
                            name = ""
                        }
                    }

                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
}

#Preview {
    ActivityView()
}
