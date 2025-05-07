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
    @StateObject var quoteManager = QuoteManager()
    @AppStorage("isDarkMode") private var isDarkMode = true
    var body: some Scene {
        WindowGroup {
            ContentView(spotifyController: spotifyController)
                .environmentObject(quoteManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
