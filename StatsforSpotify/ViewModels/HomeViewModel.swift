//
//  HomeViewModel.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/7/25.
//

import Foundation

class HomeViewModel : ObservableObject {
    //make variables published to ensure our view can have access to them
    @Published var userProfile: UserProfile?
    @Published var topTracks: UserTopTracksResponse?
    @Published var topArtists: UserTopArtistResponse?
    @Published var topGenres: [String] = []
    @Published var quote: QuoteResponse?
    @Published var showError = false
    
    var spotifyController: SpotifyController!
    var quoteManager: QuoteManager!
    
    //func to load all our data on load of the homeview page
    //these will only run if the data is nil (haven't been called yet)
    //as such, there will only be one call made to each function
    //and when you leave the home screen, a new quote won't be loaded
    //nor will the quotes-reanimate themselves
    func loadAllData() async {
        if userProfile == nil { await fetchUserProfile() }
        if topTracks == nil { await fetchTopTracks() }
        if topArtists == nil { await fetchTopArtists() }
        if topGenres.isEmpty { await fetchTopGenres() }
        if quote == nil { await fetchMusicQuotes() }
    }
    
    //functions moved from the homeview
    
    private func fetchUserProfile() async {
        guard let apiManager = spotifyController.apiManager else {
            showError = true
            return
        }
        
        do {
            userProfile = try await apiManager.getUserProfile()
        } catch {
            showError = true
            print("Profile fetch error:", error.localizedDescription)
        }
    }
    
    private func fetchTopTracks() async {
        guard let apiManager = spotifyController.apiManager else {
            showError = true
            return
        }
        
        do {
            topTracks = try await apiManager.getUserTopTracks()
        } catch {
            showError = true
            print("Failed to fetch top tracks:", error.localizedDescription)
        }
    }
    
    private func fetchTopArtists() async {
        guard let apiManager = spotifyController.apiManager else {
            showError = true
            return
        }
        
        do {
            topArtists = try await apiManager.getUserTopArtists()
        } catch {
            showError = true
            print("Failed to fetch top tracks:", error.localizedDescription)
        }
    }
    
    private func fetchTopGenres() async {
        guard let apiManager = spotifyController.apiManager else {
            showError = true
            return
        }
        
        do {
            topGenres = try await apiManager.getUserTopGenres()
            print(topGenres)
        } catch {
            showError = true
            print("Failed to fetch top genres:", error.localizedDescription)
        }
    }
    
    private func fetchMusicQuotes() async {
        do {
            quote = try await quoteManager.getRandomQuote()
        } catch {
            print("Failed to fetch quote: \(error.localizedDescription)")
        }
    }
}
