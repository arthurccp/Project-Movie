//
//  ContentView.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MoviewViewModel()
    
    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location   : CGPoint = CGPoint(x: 0, y: 0)

    var body: some View {
        NavigationView{
                ZStack{
                    VStack{
                        if let movies = viewModel.movies{
                            MoviesListView(viewModel: viewModel, movies: movies)
                        }else{
                            loadingView()
                        }
                    }
                    .frame(maxHeight: .infinity)
                    GeometryReader { reader in
                        BottomSheet()
                            .offset(y: reader.frame(in: .global).height-60)
                            .offset(y: offset)
                            .gesture(DragGesture().onChanged({ (value) in
                                withAnimation{
                                    translation = value.translation
                                    location    = value.location
                                    
                                    if value.location.y > reader.frame(in: .global).midX{
                                        if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 60){
                                            offset = value.translation.height
                                        }
                                    }
                                    if value.location.y < reader.frame(in: .global).midX{
                                        if value.translation.height > 0 && offset < 0{
                                            offset = (-reader.frame(in: .global).height + 60) + translation.height
                                        }
                                    }
                                }
                            }).onEnded({ (value) in
                                withAnimation {
                                    if value.startLocation.y > reader.frame(in: .global).midX{
                                        if -value.translation.height > reader.frame(in: .global).midX{
                                            offset = (-reader.frame(in: .global).height + 60)
                                            return
                                        }
                                        
                                        offset = 0
                                    }
                                    if value.startLocation.y > reader.frame(in: .global).midX{
                                        if value.translation.height < reader.frame(in: .global).midX{
                                        offset = (-reader.frame(in: .global).height + 60)
                                        return
                                    }
                                        offset = 0
                                }
                            }
                        }))
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



struct BottomSheet: View {
    
    @State var text = ""
    
    var body: some View {
        VStack{
            Capsule()
                .fill(Color(white: 0.95))
                .frame(width: 50, height: 5)
            
            TextField("Pesquisar", text: $text)

            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading){
                    ForEach(1...30, id: \.self){
                        Text("Ola \($0)")
                    }
                }
            })
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
        .padding(.top, 20)
        .background(BlurShape())
        
    }
}


struct BlurShape: UIViewRepresentable{
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct SearchBar: UIViewRepresentable {
  typealias UIViewType = UISearchBar
  

  func makeUIView(context: Context) -> UISearchBar {
      let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.searchBarStyle = .minimal
    searchBar.placeholder = "Procure por um Filme..."
    return searchBar
  }
  
  func updateUIView(_ uiView: UISearchBar, context: Context) {
  }
  
  func makeCoordinator() -> SearchBarCoordinator {
    return SearchBarCoordinator()
  }
  
  class SearchBarCoordinator: NSObject, UISearchBarDelegate {
    

  }
}


struct MovieView: View {
    var movie: Movie
    
    var body: some View{
        HStack(spacing: 15) {
            WebImage(url: URL(string:  "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"))
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
        }
    }
}

struct MoviesListView: View {
    
    @ObservedObject var viewModel: MoviewViewModel

    var movies: [Movie]
    var body: some View{
        List{
            ForEach(movies){ movie in
                MovieView(movie:movie)
                    .padding(.vertical)
                    .onAppear(){
                        viewModel.fetchDataIfNeeded(movie: movie)
                        
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
