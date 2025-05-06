//
//  ContentView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/6/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var spotifyController = SpotifyController()
    
    var body: some View {
        Group {
            if spotifyController.isAuthenticated {
                //start the navigation stack here in home view
                NavigationStack {
                    HomeView(spotifyController: spotifyController)
                        .navigationBarBackButtonHidden(true)
                }
            } else {
                WelcomeView(spotifyController: spotifyController)
            }
        }
        .onOpenURL { url in
            spotifyController.handleRedirectURL(url)
        }
    }
}

#Preview {
    ContentView(spotifyController: SpotifyController())
}
