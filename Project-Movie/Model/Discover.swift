//
//  Discover.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

import Foundation


struct Discover: Decodable{
    let results: [Movie]
    let total_pages: Int
}

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String
    let vote_average: Float
}
