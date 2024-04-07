//
//  LocationVideoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/04/2024.
//

import SwiftUI
import AVKit

struct LocationVideoView: View {
    let videos: [Video]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                BackgroundView()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(videos) { video in
                            VStack(alignment: .leading) {
                                VideoPlayer(player: AVPlayer(url: URL(string: video.videoURL)!))
                                    .frame(height: 250)
                                
                                Text(video.title ?? "")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Videos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                }
            }
        }
    }
}

#Preview {
    LocationVideoView(videos: [Video]())
}
