//
//  ContentView.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

//https://github.com/SDWebImage/SDWebImageSwiftUI.git

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MoviewViewModel()

    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    @State var location   : CGPoint = CGPoint(x: 0, y: 0)
    
    @StateObject var searchView = SearchUserViewModel()



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
                    BottomSheet(viewModel: searchView)
                            .offset(y: reader.frame(in: .global).height-60)
                            .offset(y: offset)
                            .gesture(DragGesture().onChanged({ (value) in
                                withAnimation{
                                    translation = value.translation
                                    location    = value.location

                                    if value.startLocation.y > reader.frame(in: .global).midX{
                                        if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 60){
                                            offset = value.translation.height
                                        }
                                    }
                                    if value.startLocation.y < reader.frame(in: .global).midX{
                                        if value.translation.height > 0 && offset < 0{
                                            offset = (-reader.frame(in: .global).height + 60) + value.translation.height
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
                                    if value.startLocation.y < reader.frame(in: .global).midX{
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

    @StateObject var viewModel = SearchUserViewModel()

    var body: some View {
        VStack{
            Capsule()
                .fill(Color(white: 0.95))
                .frame(width: 50, height: 5)
            
                SearchUserBar(text: $viewModel.name) {
                    self.viewModel.search()
                }
                List(viewModel.users) { user in
                    SearchUserRow(viewModel: self.viewModel, user: user)
                }

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

