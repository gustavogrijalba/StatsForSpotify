//
//  WelcomeView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/8/25.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var spotifyController: SpotifyController
    
    var body: some View {
        VStack(spacing: 50) {
            Image("spotify")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Button(action: {
                spotifyController.startAuthFlow()
            }) {
                Text("SIGN IN WITH SPOTIFY")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(Color.green)
                    .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
