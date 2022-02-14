//struct SearchUserResponse: Decodable {
//    var items: [User]
//}
struct Discover_s: Decodable{
    let results: [Movie]
    let total_pages: Int
}
