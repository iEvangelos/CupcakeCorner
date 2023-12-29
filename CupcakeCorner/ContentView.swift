//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Evangelos Pipis on 29/12/2023.
//

import SwiftUI

// A Response will store an array of results.
struct Response: Codable {
    var results: [Result]
}

// A Result will store a track ID, its name, and the album it belongs to.
struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        // We want the loadData() function to be run as soon as our List is shown, but we can’t just use onAppear() here because that doesn’t know how to handle sleeping functions – it expects its function to be synchronous.
        // .task can call functions that might go to sleep for a while; all Swift asks us to do is mark those functions with a second keyword, await, so we’re explicitly acknowledging that a sleep might happen.
        .task {
            await loadData()
        }
    }
    
    
    func loadData() async {
        // The URL needs to have a precise format: “itunes.apple.com” followed by a series of parameters
        // More information about the API can be found here: https://performance-partners.apple.com/search-api
        guard let taylorSwiftURL = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // A sleep is possible here, and every time a sleep is possible we need to use the await keyword with the code we want to run. Just as importantly, an error might also be thrown here – maybe the user isn’t currently connected to the internet, for example.
        do {
            let (data, _) = try await URLSession.shared.data(from: taylorSwiftURL)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
