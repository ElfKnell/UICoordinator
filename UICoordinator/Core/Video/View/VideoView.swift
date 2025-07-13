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
    @EnvironmentObject var viewModel: VideoViewModel
    
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
                                    
                                TitleVideoView(video: video, title: video.title ?? "")
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchVideoByLocation()
                    }
                }
                .task {
                    viewModel.locationId = locationId
                    await viewModel.fetchVideoByLocation()
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
