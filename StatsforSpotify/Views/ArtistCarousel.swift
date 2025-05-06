//
//  ArtistCarousel.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 4/27/25.
//

import SwiftUI

//the exact same as the track carousel
struct ArtistCarousel: View {
    @ObservedObject var spotifyController: SpotifyController
    let items: [SpotifyTopArtist]
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: TopArtistsListView(spotifyController: spotifyController)) {
                HStack {
                    Text("Your Top Artists")
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
                                ForEach(Array(items.enumerated()), id: \.element.id) { (index, artist) in
                                    ArtistCard(rank: index + 1, artist: artist)
                                        .frame(width: UIScreen.main.bounds.width * 0.4)
                                }
                            }
                .padding(.vertical, 8)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }}
