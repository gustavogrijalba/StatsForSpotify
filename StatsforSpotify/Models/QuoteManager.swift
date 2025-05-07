//
//  QuoteManager.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/6/25.
//

import Foundation

class QuoteManager: ObservableObject {
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
        
        guard let firstQuote = quotes.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return firstQuote
    }
}

struct QuoteResponse: Codable {
    let q: String
    let a: String
}
