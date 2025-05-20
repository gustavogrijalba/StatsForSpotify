//
//  QuoteManager.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/6/25.
//

import Foundation

class QuoteManager: ObservableObject {
    //get a random quote
    //ideally id be able to get quotes or lyrics related to music,
    //however all apis that get a lyric are paywalled or otherwise
    //not public to use
    private var baseURL = "https://zenquotes.io/api/random"
    
    func getRandomQuote () async throws -> QuoteResponse {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let quotes = try decoder.decode([QuoteResponse].self, from: data)
        //we get an array of quotes, which we don't need
        //we only grab the first quote and return it as we will not display the array of quotes returned
        guard let firstQuote = quotes.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return firstQuote
    }
}

struct QuoteResponse: Codable {
    //our struct is like this to fit the json response
    //where q is the quote itself and
    //a is the author, making it simple to use as we wouldnt need a fancy decoder
    let q: String
    let a: String
}
