//
//  HomeView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/21/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var quoteManager : QuoteManager
    @ObservedObject var spotifyController: SpotifyController
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var showQuote = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                //show a music quote
                if let quote = viewModel.quote {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("“\(quote.q)”")
                            .font(.title3)
                            .italic()
                            .lineLimit(3)
                            .truncationMode(.tail)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("- \(quote.a)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                    .opacity(showQuote ? 1 : 0)
                    .offset(y: showQuote ? 0 : 20)
                    .animation(.easeOut(duration: 0.6), value: showQuote)
                    .onAppear {
                        showQuote = true
                    }
                }
                //populate genres once response is received
                if (viewModel.topGenres != []) {
                    GenreView(genres: viewModel.topGenres)
                }
                //allow us to display tracks in a carousel
                if let tracks = viewModel.topTracks?.items {
                    TrackCarousel(spotifyController: spotifyController, items: tracks)
                        .padding(.top, 8)
                }
                
                if let artists = viewModel.topArtists?.items {
                    ArtistCarousel(spotifyController: spotifyController, items: artists)
                        .padding(.top, 8)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            //title for the entire page
            .navigationTitle("Home")
            //add a toolbar that will function as our slight profile menu
            //as well as our layout structure
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 8) {
                        if let profile = viewModel.userProfile {
                            // use async image to fetch the image from the spotify's
                            //userprofile struct which provides the image url
                            //and display it in the UI
                            Menu {
                                Button {
                                    isDarkMode.toggle()
                                } label: {
                                    Label("Toggle Dark Mode", systemImage: "moon.fill")
                                }
                            } label: {
                                AsyncImage(url: URL(string: profile.images?.first?.url ?? "")) { image in
                                    image.resizable()
                                } placeholder: { //placeholder before loading the user's image from the spotify api response
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            }
                            //make the home page seem a bit more personal
                            //by adding the user's name
                            Text("Welcome, \(profile.displayName)")
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
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text("Failed to load profile data")
            }
            //prev, api calls were made once more after coming back from a new
            //screen in the navigation stack, now we check to ensure
            //we keep on call at a time
            .task {
                viewModel.spotifyController = spotifyController
                viewModel.quoteManager = quoteManager
                await viewModel.loadAllData()
            }

        }
    }
}
