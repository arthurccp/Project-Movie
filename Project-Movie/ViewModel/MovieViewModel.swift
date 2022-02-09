//
//  MovieViewModel.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

import Foundation

class MoviewViewModel: ObservableObject{
    func fetchData(){
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=e6dc8c20ea0d4c49874b8fa5173a1309")
        
        URLSession.shared.dataTask(with: url!) { data, resspondse, error in
            if let error = error{
                print(error)
                return
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                }catch(let error){
                    print(error)
                    return
                }
                
            }else{
                print("error \(error)")
                return
            }
        }.resume()
    }
}
