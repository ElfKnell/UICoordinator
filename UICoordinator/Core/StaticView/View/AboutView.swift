//
//  AboutView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 30/03/2024.
//

import SwiftUI

struct AboutView: View {
    
    @State var viewModel = AboutViewModel()
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 32) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("🌟 Welcome to Trailcraft")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Discover. Tag. Share.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 28))
                            .foregroundStyle(.blue)
                        
                        Text("Custom Beacons on Interactive Maps")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.info_1)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "message.and.waveform")
                            .font(.system(size: 28))
                            .foregroundStyle(.green)
                        
                        Text("Real-Time Social Sharing")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.info_2)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "globe.europe.africa")
                            .font(.system(size: 28))
                            .foregroundStyle(.red)
                        
                        Text("All-in-One Experience")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(viewModel.info_3)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Explore the Features")
    }
}

#Preview {
    AboutView()
}
