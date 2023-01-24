//
//  AllCoinsView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct AllCoinsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let isPortfolio: Bool
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    
    init(isPortfolio: Bool = false) {
        self.isPortfolio = isPortfolio
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(isPortfolio ? "Your coins" : "All coins")
                .font(.headline)
                .padding()
            
            listHeader
            
            coinsList
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: {
                EmptyView()
            })
        )
    }
}

struct AllCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AllCoinsView(isPortfolio: false)
                .environmentObject(dev.homeVM)
            
            AllCoinsView(isPortfolio: true)
                .environmentObject(dev.homeVM)
        }
    }
}

extension AllCoinsView {
    private var coinsList: some View {
        ScrollView {
            VStack {
                ForEach(isPortfolio ? viewModel.portfolioCoins : viewModel.coins) { coin in
                    CoinRowView(coin: coin, isPortfolio: isPortfolio)
                        .onTapGesture {
                                segue(coin: coin)
                        }
                }
            }
        }
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var listHeader: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            HStack(spacing: 4)  {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            
            if isPortfolio {
                HStack(spacing: 4)  {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                    .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
                    .onTapGesture {
                        withAnimation(.default) {
                            viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                        }
                    }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: viewModel.isLoading ? 360: 0), anchor: .center)
            }

        }
        .foregroundColor(Color.theme.secondaryColor)
        .padding(.horizontal)
        .font(.caption)

    }
}
