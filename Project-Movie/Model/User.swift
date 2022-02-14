import Foundation
import SwiftUI




struct Movie_s: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String
    let vote_average: Float
}

//struct User: Hashable, Identifiable, Decodable {
//    var id: Int64
//    var login: String
//    var avatar_url: URL
//}
