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
                //otherwise, start the view
                //at the welcome view where the user can login into their spotify
                WelcomeView(spotifyController: spotifyController)
            }
        }
        .onOpenURL { url in
            spotifyController.handleRedirectURL(url)
        }
    }
}
