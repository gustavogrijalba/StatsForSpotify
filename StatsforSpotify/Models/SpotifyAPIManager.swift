//
//  SpotifyAPIManager.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 3/18/25.
//

import Foundation
import Combine

class SpotifyAPIManager: ObservableObject {
    //base url of all api requests we will be making
    private let baseURL = "https://api.spotify.com/v1/"
    //our access token given by our spotifycontroller which handles authorization
    private var accessToken : String
    
    //init our access token to make api requests
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    /// api call to get the user profile details
    /// - Returns: UserProfile struct which I have defined in the file, a codable struct to retrieve the details
    func getUserProfile() async throws -> UserProfile {
        //create the endpoint url from which we will call the API
        guard let url = URL(string: baseURL + "me") else {
            throw URLError(.badURL)
        }
        
        //construct our request using our URL
        //we will need to add our auth token to the header
        var request = URLRequest(url: url)
        request.setValue(("Bearer " + accessToken), forHTTPHeaderField: "Authorization")
        
        //use url session to call the api endpoint
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //validate our response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //decode our json response and populate our codable userprofile struct
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(UserProfile.self, from: data)
    }
    
    //the same function as the top tracks-> separated to return topartist instead of top tracks
    func getUserTopArtists(time_range : String = "medium_term", limit : Int = 20) async throws -> UserTopArtistResponse {
        //create our endpoint url for the top tracks
        guard let url = URL(string: baseURL + "me/top/artists?time_range=\(time_range)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        //construct our request using our URL
        //we will need to add our auth token to the header
        var request = URLRequest(url: url)
        request.setValue(("Bearer " + accessToken), forHTTPHeaderField: "Authorization")
        
        //use url session to call the api endpoint
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //validate our response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //decode our json response and populate our codable usertopartists struct
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(UserTopArtistResponse.self, from: data)
    }
    
    //the endpoint for top genres no longer exists, so the strategy is to get the top artists,
    //and count the top genres in a dictionary and return an array of the most listened to genres
    func getUserTopGenres(time_range : String = "medium_term", limit : Int = 20) async throws -> [String] {
        //create our endpoint url for the top tracks
        guard let url = URL(string: baseURL + "me/top/artists?time_range=\(time_range)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        //construct our request using our URL
        //we will need to add our auth token to the header
        var request = URLRequest(url: url)
        request.setValue(("Bearer " + accessToken), forHTTPHeaderField: "Authorization")
        
        //use url session to call the api endpoint
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //validate our response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //decode our json response and populate our codable usertopartists struct
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let userTopArtistData = try decoder.decode(UserTopArtistResponse.self, from: data);
        //calculate the top genre data by first using flat to create one singular array of all
        //genres (since one artist can have multiple genres, so we have multiple arrays
        let genres = userTopArtistData.items.flatMap{$0.genres}
        //count the frequency of each genre by adding it to a dictionary
        //easy access to sort and return an array
        let genreFrequency = Dictionary(grouping: genres, by: { $0 }).mapValues { $0.count }
        //return an array of the sorted dictionary
        return genreFrequency.sorted { $0.value > $1.value }.map { $0.key }
    }
    
    func getUserTopTracks(time_range : String = "medium_term", limit : Int = 20) async throws -> UserTopTracksResponse {
        //create our endpoint url for the top tracks
        guard let url = URL(string: baseURL + "me/top/tracks?time_range=\(time_range)&limit=\(limit)") else {
            throw URLError(.badURL)
        }
        
        //construct our request using our URL
        //we will need to add our auth token to the header
        var request = URLRequest(url: url)
        request.setValue(("Bearer " + accessToken), forHTTPHeaderField: "Authorization")
        
        //use url session to call the api endpoint
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //validate our response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //decode our json response and populate our codable usertoptracks struct
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(UserTopTracksResponse.self, from: data)
    }
    
}

//spotify api has its own image object in the response json
//making a spotify image struct, we can reuse this for all items that need an image
struct SpotifyImage: Codable {
    let url: String?
    let height: Int?
    let width: Int?
}

//for the user profile's basic information for a more personal UI
//using codable so that swift
struct UserProfile : Codable {
    let displayName : String
    let images : [SpotifyImage]?
}

//will use this struct to display the tracks that are used
//will maximize all the information i can gather on the track
//so that i can potentially create a view where we can view individual tracks and play it on the app
struct UserTopTracksResponse : Codable {
    //i receive a spotifyTrack object, which i will need to unpack from the API response
    let items : [SpotifyTrack]
}

struct SpotifyAlbum: Codable {
    let images: [SpotifyImage]
    let name: String
}

struct SpotifyArtist : Codable {
    let name: String
}

struct SpotifyTrack : Codable, Identifiable {
    let id : String
    //album contains the image of the album that i want to display, so i need to grab that
    //also grabbing the album name in case i can display it somehow
    let album : SpotifyAlbum
    //arist object, i only need the name from that part of the response
    let artists : [SpotifyArtist]
    let name : String
}

struct UserTopArtistResponse : Codable {
    let items : [SpotifyTopArtist]
}

struct SpotifyTopArtist : Codable, Identifiable {
    let id : String
    let name : String
    let images: [SpotifyImage]
    let genres : [String]
    
}
