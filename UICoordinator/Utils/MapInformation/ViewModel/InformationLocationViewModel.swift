//
//  InformationLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import Foundation
import MapKit
import FirebaseCrashlytics

@MainActor
class InformationLocationViewModel: ObservableObject {
    
    @Published var loadingState = LoadingState.loading
    @Published var pages = [Page]()
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(coordinate.latitude)%7C\(coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            Crashlytics.crashlytics().log("Invalid URL for Wikipedia API")
            return
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted { $0.title < $1.title }
            loadingState = .loaded
            
        } catch {
            
            loadingState = .failed
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics()
                .log("Failed to fetch nearby Wikipedia pages for coordinate: \(coordinate.latitude), \(coordinate.longitude)")
            
        }
    }
}
