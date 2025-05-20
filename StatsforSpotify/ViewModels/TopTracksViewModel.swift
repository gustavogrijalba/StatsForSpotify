//
//  TopTracksViewModel.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/7/25.
//

import Foundation

class TopTracksViewModel: ObservableObject {
    var spotifyController: SpotifyController!
    @Published var topTracks: UserTopTracksResponse?
    @Published var isLoading: Bool = false
    @Published var selectedTimeRange: TimeRange = .shortTerm
    
    func fetchTopTracks() async {
        isLoading = true
        defer { isLoading = false }
        do {
            topTracks = try await spotifyController.apiManager?.getUserTopTracks(time_range: selectedTimeRange.apiValue, limit: 50)
        } catch {
            print("Failed to fetch top tracks: \(error)")
        }
    }
}
