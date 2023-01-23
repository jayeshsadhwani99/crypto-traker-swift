//
//  HomeView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false // swipe right
    
    @State private var showPortfolioView: Bool = false // shows portfolio page
    
    var body: some View {
        ZStack (alignment: .leading) {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                }

            
            // content
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                if !showPortfolio {
                    homeCoinsView
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsView
                    .transition(.move(edge: .trailing))
                }
                    
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if (showPortfolio) {
                        showPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Crypto Tracker")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees:  showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var homeCoinsView: some View {
        ScrollView (.vertical, showsIndicators: false) {
            // top movers view
            TopMoversView()
            
            Divider()
            
            SearchBarView(searchText: $viewModel.searchText)
            
            // all coins view
            AllCoinsView(isPortfolio: showPortfolio)
        }
    }
    
    private var portfolioCoinsView: some View {
        ScrollView (.vertical, showsIndicators: false) {
            // coins view
            AllCoinsView(isPortfolio: showPortfolio)
        }
    }
}
