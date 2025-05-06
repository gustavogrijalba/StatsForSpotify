//
//  StatsforSpotifyApp.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/6/25.
//

import SwiftUI

@main
struct StatsforSpotifyApp: App {
    @StateObject var spotifyController = SpotifyController()
    var body: some Scene {
        WindowGroup {
            ContentView(spotifyController: spotifyController)
        }
    }
}
