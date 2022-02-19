import SwiftUI
import Combine

final class SearchUserViewModel: ObservableObject {

    @Published var name = "Rick"
 
    @Published private(set) var users = [Result]()
    
    private var searchCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        searchCancellable?.cancel()
    }

    func search() {
        guard !name.isEmpty else {
            return users = []
        }

        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "840ad3585933c9e95f925127c092c385"),
            URLQueryItem(name: "query", value: name),
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        searchCancellable = URLSession.shared.dataTaskPublisher(for: request)  
            .map { $0.data }
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .map { $0.results }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.users, on: self)
        
    }

}
