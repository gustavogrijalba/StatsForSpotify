//
//  SpotifyController.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/6/25.
//
import SwiftUI
import SpotifyiOS
import Combine


class SpotifyController: NSObject, ObservableObject, SPTAppRemoteDelegate {
    //the following three functions are needed to conform to sptappremotedelegate
    //which i wanted to do so that authorization would open the spotify app instead of
    //the safari app, which i thought wouldn't be as smooth of a connection
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify App Remote did establish connection.")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Spotify App Remote failed to connect: \(error?.localizedDescription ?? "unknown error")")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Spotify App Remote disconnected: \(error?.localizedDescription ?? "unknown error")")
    }
    
    private let clientID = "38d62ee8ef334561893e630fa653d869"
    private let redirectURI = "spotify-ios-quick-start://spotify-login-callback"
    
    @Published var apiManager: SpotifyAPIManager?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var accessToken: String? = nil
    
    //scopes are what we need to do certain things in spotify, and these will change on a case by case basis
    //need scope to read the top items of a user
    var scopes: [String] = [
        "user-top-read",
    ]
    
    //this is what will allow us to actually open spotify instead of safari
    lazy var configuration = SPTConfiguration(clientID: clientID, redirectURL: URL(string: redirectURI)!)
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func startAuthFlow() {
        //a spotify function that plays a song (in this case empty), while allowing us to add our scopes
        //other params are not needed other than additional scopes,
        //the spotify app can only auth if we play a song in the app, which is why we need to play an empty song
        //will pause any other media playing on the device
        appRemote.authorizeAndPlayURI("", asRadio: false, additionalScopes: scopes)
    }
    
    //handle redirecturi is what allows us to get the access token and set it to start up the app
    func handleRedirectURL(_ url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            DispatchQueue.main.async {
                self.accessToken = accessToken
                self.isAuthenticated = true
                self.apiManager = SpotifyAPIManager(accessToken: accessToken)
            }
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("Spotify Authentication failed with error: \(errorDescription)")
        }
    }
}
