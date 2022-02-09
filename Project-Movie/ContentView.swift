//
//  ContentView.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MoviewViewModel()

    var body: some View {
        NavigationView{
            ZStack{
                if let movies = viewModel.movies{
                    MoviesListView(movies: movies)
                }else{
                    Text("Fetching data...")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Popular Movies")
        }
        .onAppear(){
        viewModel.fetchData()
            }
            .padding()
    }
}
struct MoviesListView: View {
    var movies: [Movie]
    var body: some View{
        List{
            ForEach(movies){ movie in
                HStack(spacing: 15) {
                    WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120)
                        .cornerRadius(8)
                    VStack(alignment: .leading, spacing: 8){
                        Text(movie.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(movie.overview ?? "" )
                            .lineLimit(4)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack(spacing: 4){
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width:  12, height: 12)
                                .foregroundColor(.orange)
                            Text(String(format: "%.1f", movie.vote_average))
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct loadingView: View {
    var body: some View{
        Text("Fetching data...")
            .foregroundColor(.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
