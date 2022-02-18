//
//  MovieViewModel.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//
import Foundation

class MoviewViewModel: ObservableObject{
    
    @Published var movies = [Movie]()
    
    var page: Int = 1
    var totalPages: Int = 1
    var isFetchingData = false
    @Published var movie: Movie?
    
    func fetchDataIfNeeded(movie: Movie) {
        if movies.last == movie && page <= totalPages && !isFetchingData {
            page += 1
            fetchData()
        }
    }

    
    func fetchData(){
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=840ad3585933c9e95f925127c092c385&page=\(page)")
        isFetchingData = true
        
        URLSession.shared.dataTask(with: url!) { data, resspondse, error in
            self.isFetchingData = false
            if let error = error{
                print(error)
                return
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    let discover = try JSONDecoder().decode(Discover.self, from: data)
                    self.totalPages = discover.total_pages
                    DispatchQueue.main.async {
                        self.movies = discover.results
                    }
                }catch(let error){
                    print(error)
                    return
                }
                
            }else{
                print("error \(String(describing: error))")
                return
            }
        }.resume()
    }
}


