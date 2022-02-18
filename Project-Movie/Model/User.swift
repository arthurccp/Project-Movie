import Foundation
import SwiftUI


struct Result:  Identifiable, Decodable, Equatable { 
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double

    
    enum CodingKeys: String, CodingKey {
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity

    }
}
