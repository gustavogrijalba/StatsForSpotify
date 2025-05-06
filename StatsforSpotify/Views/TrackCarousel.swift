//
//  TrackCarousel.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 4/15/25.
//

import SwiftUI

struct TrackCarousel: View {
    @ObservedObject var spotifyController: SpotifyController
    let items: [SpotifyTrack]
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: TopTracksListView(spotifyController: spotifyController)) {
                HStack {
                    Text("Your Top Tracks")
                        .font(.title2.bold())
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(Array(items.enumerated()), id: \.element.id) { (index, track) in
                                    TrackCard(rank: index + 1, track: track)
                                        .frame(width: UIScreen.main.bounds.width * 0.4)
                                }
                            }
                .padding(.vertical, 8)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
