//
//  HomeView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                // top movers view
                TopMoversView()
                
                Divider()
                
                // all coins view
                AllCoinsView(viewModel: viewModel)
            }
            .navigationTitle("Crypto Traker")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
