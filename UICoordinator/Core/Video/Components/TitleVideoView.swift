//
//  TitleVideoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/03/2024.
//

//import SwiftUI
//
//struct TitleVideoView: View {
//    var video: Video
//    @State var title: String
//    @EnvironmentObject var viewModel: VideoViewModel
//    @State private var isLoaded = true
//    
//    var body: some View {
//            
//        HStack {
//            TextField("Title...", text: $title)
//                .frame(width: 250)
//                
//            Spacer()
//                
//            if isLoaded {
//                
//                Button {
//                    Task {
//                        isLoaded = false
//                        await viewModel.uploadTitle(vId: video.id, title: title)
//                        isLoaded = true
//                    }
//                } label: {
//                    Image(systemName: "externaldrive.fill.badge.checkmark")
//                        .font(.title2)
//                        .foregroundStyle(.green)
//                }
//                
//                Button {
//                    Task {
//                        await viewModel.deleteVideo(video)
//                    }
//                } label: {
//                    Image(systemName: "trash.circle.fill")
//                        .font(.title2)
//                        .foregroundStyle(.red)
//                }
//                
//            } else {
//                LoadingView(width: 30, height: 30)
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    TitleVideoView(video: DeveloperPreview.video, title: "")
//}
