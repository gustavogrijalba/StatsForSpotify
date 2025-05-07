//
//  ArtistCard.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 4/27/25.
//

import SwiftUI

struct ArtistCard: View {
    let rank: Int
    let artist: SpotifyTopArtist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: artist.images.first?.url ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            HStack(alignment: .top, spacing: 6) {
                Text("\(rank).")
                    .font(.subheadline.bold())
                VStack(alignment: .leading, spacing: 2) {
                    Text(artist.name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
