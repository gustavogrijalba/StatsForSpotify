//
//  GenreView.swift
//  StatsforSpotify
//
//  Created by Gustavo  Grijalba on 5/6/25.
//

import SwiftUI

struct GenreView: View {
    //will receive this from our api call
    let genres: [String]
    //variable to make our bar chart animate
    @State private var animateBars = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Top Genres")
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            
            //show only 5 genres for the interest of space in the home view
            ForEach(Array(genres.prefix(5).enumerated()), id: \.1) { index, genre in
                //although we are mimicking a bar chart, because our genre array doesn't have real data
                //(we are ranking purely from the way its give, as in our genre api we return an array of a
                //sorted genre array), we cannot use the bar chat since we have data
                HStack {
                    //display the genre in the order of most listened to least listened
                    //genres displayed will be in order (top 5)
                    Text("\(index + 1). \(genre)")
                        .font(.subheadline)
                        .frame(width: 120, alignment: .leading)
                    
                    GeometryReader { geometry in
                        //get the width of the container/screen that top genres is being held in
                        let maxWidth = geometry.size.width
                        //create a rectangle for each individual genre
                        Rectangle()
                            .fill(Color.green) //green for the spotify color
                        //make each rectangle different by using its index
                            .frame(width: animateBars ? maxWidth * CGFloat(1.0 - (Double(index) * 0.15)) : 0,
                                   height: 10)
                            .cornerRadius(5)
                            .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateBars)
                    }
                    .frame(height: 10)
                }
            }
        }
        .padding()
        .onAppear {
            animateBars = true
        }
    }
}
