//
//  AboutViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 30/03/2024.
//

import Foundation

class AboutViewModel: ObservableObject {
    
    @Published var info_1 = "Introducing our innovative action application! With our platform, you can effortlessly place customizable beacons on interactive maps, marking your favorite spots or important locations with ease. Not only can you tag these beacons with personalized information, but you can also enrich them with vivid photos and captivating videos, adding depth and context to your mapped points of interest."
    
    @Published var info_2 = "But that's not all! Our app takes social interaction to the next level by allowing you to share your locations in real-time chat, where fellow users can engage with your posts by commenting and liking. Whether you're exploring new destinations, organizing events, or simply sharing memorable experiences, our action application provides the perfect blend of mapping, multimedia, and social connectivity for your every need."
}
