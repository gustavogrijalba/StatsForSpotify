//
//  HomeView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/21/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var spotifyController: SpotifyController
    @State private var userProfile: UserProfile?
    @State private var showError = false
    @State private var topTracks: UserTopTracksResponse?
    @State private var topArtists: UserTopArtistResponse?
    @State private var topGenres: [String] = []
    
    var body: some View {
            VStack(spacing: 0) {
                //populate genres once response is received
                if (topGenres != []) {
                    GenreView(genres: topGenres)
                }
                //allow us to display tracks in a carousel
                if let tracks = topTracks?.items {
                    TrackCarousel(spotifyController: spotifyController, items: tracks)
                        .padding(.top, 8)
                }
                
                if let artists = topArtists?.items {
                    ArtistCarousel(spotifyController: spotifyController, items: artists)
                        .padding(.top, 8)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 8) {
                        if let profile = userProfile {
                            // use async image to fetch the image from the spotify's
                            //userprofile struct which provides the image url
                            //and display it in the UI
                            AsyncImage(url: URL(string: profile.images?.first?.url ?? "")) { image in
                                image.resizable()
                            }
                            //placeholder before loading the user's image from the spotify
                            //api response
                            placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            
                            Text("Welcome, \(profile.displayName)")
                                .font(.subheadline)
                        } else {
                            //placeholder before loading
                            Image(systemName: "person.crop.circle")
                                .imageScale(.large)
                            Text("Welcome")
                                .font(.subheadline)
                        }
                    }
                    .padding(.leading, 8)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text("Failed to load profile data")
            }
            .task {
                await fetchUserProfile()
                await fetchTopTracks()
                await fetchTopArtists()
                await fetchTopGenres()
            }
    }
    
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
}

#Preview {
    HomeView(spotifyController: SpotifyController())
}
