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
    
    init(isPortfolio: Bool = false) {
        self.isPortfolio = isPortfolio
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(isPortfolio ? "Your coins" : "All coins")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Coin")
                
                Spacer()
                
                Text("Prices")
                
                if isPortfolio {
                    Text("Holdings")
                        .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
                }
            }
            .foregroundColor(Color.theme.secondaryColor)
            .padding(.horizontal)
            .font(.caption)
            
            ScrollView {
                VStack {
                    ForEach(isPortfolio ? viewModel.portfolioCoins : viewModel.coins) { coin in
                        CoinRowView(coin: coin, isPortfolio: isPortfolio)
                    }
                }
            }
        }
    }
}

struct AllCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        AllCoinsView(isPortfolio: false)
            .environmentObject(dev.homeVM)
    }
}
