//
//  ContentView.swift
//  Project-Movie
//
//  Created by Arthur Silva on 09/02/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MoviewViewModel()

    var body: some View {
        Text("Hello, world!")
            .onAppear(){
                viewModel.fetchData()
            }
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
