//
//  CoinLogoView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import SwiftUI
import Kingfisher

struct CoinLogoView: View {
    let coin: Coin
    
    var body: some View {
        VStack {
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
    }
}
