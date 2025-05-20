//
//  TopArtistsViewModel.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/7/25.
//

import Foundation

class TopArtistsViewModel: ObservableObject {
    @Published  var topArtists: UserTopArtistResponse?
    @Published  var isLoading: Bool = false
    @Published  var selectedTimeRange: TimeRange = .shortTerm
    
    var spotifyController: SpotifyController!
    
    func fetchTopTracks() async {
        isLoading = true
        defer { isLoading = false }
        do {
            topArtists = try await spotifyController.apiManager?.getUserTopArtists(time_range: selectedTimeRange.apiValue, limit: 50)
        } catch {
            print("Failed to fetch top tracks: \(error)")
        }
    }
}
