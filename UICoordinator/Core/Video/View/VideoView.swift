//
//  VideoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/03/2024.
//

import SwiftUI
import PhotosUI
import AVKit

struct VideoView: View {
    
    let locationId: String
    let isAccessible: Bool
    @StateObject var viewModel = VideoViewModel()
    
    var body: some View {
            
        ZStack {
            BackgroundView()
                
            if viewModel.isLoaded {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.locationVideo) { video in
                            VStack(alignment: .leading) {
                                VideoPlayer(player: AVPlayer(url: URL(string: video.videoURL)!))
                                    .frame(height: 250)
                                    
                                TitleVideoView(vId: video.id, title: video.title ?? "", viewModel: viewModel)
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        try await viewModel.fetchVideoByLocation()
                    }
                }
                .onAppear {
                    viewModel.locationId = locationId
                    Task {
                        try await viewModel.fetchVideoByLocation()
                    }
                }
                .navigationTitle("Videos")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    
                    if isAccessible {
                        ToolbarItem(placement: .topBarTrailing) {
                            PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.videos, .not(.images)])) {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        BackButtonView()
                    }
                }
            } else {
                LoadingView(width: 130, height: 130)
            }
        }
    }
}

#Preview {
    VideoView(locationId: "", isAccessible: false)
}
