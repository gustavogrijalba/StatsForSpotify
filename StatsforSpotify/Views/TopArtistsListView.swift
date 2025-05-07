//
//  TopArtistsListView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 4/27/25.
//

import SwiftUI

//helper enum that we will use to stylize our picker
//wanted it to be similar to other spotify trackers
//that use "past month, past 6 months, past year"
//which also makes it more human readable
enum TimeRangeArtist: String, CaseIterable {
    case shortTerm = "short_term"
    case mediumTerm = "medium_term"
    case longTerm = "long_term"
    
    //each case will have it's display name, that we will convert to the case for the api call
    var displayName: String {
        switch self {
        case .shortTerm:
            return "Past Month"
        case .mediumTerm:
            return "Past 6 Months"
        case .longTerm:
            return "Past Year"
        }
    }
    //what we will be using to send to the api
    var apiValue: String {
        return self.rawValue
    }
}

struct TopArtistsListView: View {
    @State private var topArtists: UserTopArtistResponse?
    @ObservedObject var spotifyController: SpotifyController
    @State private var isLoading: Bool = false
    @State private var selectedTimeRange: TimeRange = .shortTerm
    
    //have two columns for our lazygrid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Your Top Artists")
                .font(.title)
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.displayName).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            //show our loading view while our api fetches data
            if isLoading {
                LoadingView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        if let items = topArtists?.items {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, artist in
                                ArtistCard(rank: index + 1, artist: artist)
                                //this padding is needed so that our trackcards show their title and aren't
                                //layered on top of each other
                                    .frame(height: 180)
                                    .padding(.bottom, 25)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onChange(of: selectedTimeRange) {
            Task {
                await fetchTopTracks()
            }
        }
        .onAppear {
            Task {
                await fetchTopTracks()
            }
        }
    }
    
    private func fetchTopTracks() async {
        isLoading = true
        defer { isLoading = false }
        do {
            topArtists = try await spotifyController.apiManager?.getUserTopArtists(time_range: selectedTimeRange.apiValue, limit: 50)
        } catch {
            print("Failed to fetch top tracks: \(error)")
        }
    }
}
