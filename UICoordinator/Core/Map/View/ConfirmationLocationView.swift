//
//  ConfirmationLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import SwiftUI
import MapKit

struct ConfirmationLocationView: View {
    let coordinate: CLLocationCoordinate2D
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @StateObject var viewModel = ConfirmationLocationViewModel()
    @Binding var isSave: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    VStack {
                        
                        TextField("Place name", text: $name)
                            .font(.callout)
                            .padding(9)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .overlay{
                                RoundedRectangle(cornerRadius: 20.0)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                        
                        TextField("Description...", text: $description, axis: .vertical)
                            .font(.footnote)
                            .padding(8)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .overlay{
                                RoundedRectangle(cornerRadius: 20.0)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack {
                        
                        Text("Coordinats")
                            .font(.title3)
                        
                        HStack {
                            Text("Lanitude:")
                            
                            Spacer()
                            
                            Text("Longitude:")
                            
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        
                        HStack {
                            Text("\(coordinate.latitude)")
                            
                            Spacer()
                            
                            Text("\(coordinate.longitude)")
                            
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                    }
                    
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .overlay{
                    RoundedRectangle(cornerRadius: 20.0)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            .navigationTitle("Create Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
            
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            try await viewModel.uploadLocation(name: name, description: description, coordinate: coordinate)
                            isSave = true
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .opacity(name.isEmpty ? 0.3 : 1.0)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ConfirmationLocationView(coordinate: .startLocation, isSave: .constant(false))
}
