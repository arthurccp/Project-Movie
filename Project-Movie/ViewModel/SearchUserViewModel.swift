import SwiftUI
import Combine

final class SearchUserViewModel: ObservableObject {

    @Published var name = "popularity.desc"
    @Published var name2 = "840ad3585933c9e95f925127c092c385"
 

    @Published private(set) var users = [Movie]()

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

        //Em verdade essa parte de buscar os filmes da API através de palavras chaves foi meu desafio hahaha de resto foi tranquilo pra mim. 
        //Na documentação da API o link a ser usado é esse aqui:  https://api.themoviedb.org/3/keyword/{keyword_id}?api_key=<<api_key>>, mas no
        //send request do próprio site da documentação ele retorna um 503 Service Unavailable, e quando preencho as variables e os path paramsm 
        //manualmente ele me retorna que " recurso solicitado não foi encontrado ", não sei se estou fazendo algo errado ou esqueci de algum detalhe.
        
        //Eu tenho um app muito semelhante que busca nomes de usuario do github, portando minha dúvida não seria diretamente em como fazer, mas de 
        //que forma, entende ? Me vendo neste cenário dentro da empresa esse seria oxato momento em que eu faria algumas perguntas a um desenvolvedor
        //com mais experiência para me exclarecer alguns pontos.
        
        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/discover/movie")!
        urlComponents.queryItems = [
            URLQueryItem(name: "sort_by", value: name),
            URLQueryItem(name: "api_key", value: name2)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        searchCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Discover.self, decoder: JSONDecoder())
            .map { $0.results }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: \.users, on: self)
    }

}

