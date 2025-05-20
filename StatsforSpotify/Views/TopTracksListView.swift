//
//  TopTracksListView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 4/16/25.
//

import SwiftUI
//helper enum that we will use to stylize our picker
//wanted it to be similar to other spotify trackers
//that use "past month, past 6 months, past year"
//which also makes it more human readable
enum TimeRange: String, CaseIterable {
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

struct TopTracksListView: View {
    @ObservedObject var spotifyController: SpotifyController
    @StateObject private var viewModel = TopTracksViewModel()
    
    //have two columns for our lazygrid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Your Top Tracks")
                .font(.title)
            
            Picker("Time Range", selection: $viewModel.selectedTimeRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.displayName).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            //show our loading view while our api fetches data
            if viewModel.isLoading {
                LoadingView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        if let items = viewModel.topTracks?.items {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, track in
                                TrackCard(rank: index + 1, track: track)
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
        .onChange(of: viewModel.selectedTimeRange) {
            Task {
                //no need to assign the spotifycontroller here
                //as it will be here already because it was assigned at appear
                await viewModel.fetchTopTracks()
            }
        }
        .onAppear {
            Task {
                viewModel.spotifyController = spotifyController
                await viewModel.fetchTopTracks()
            }
        }
    }
}
