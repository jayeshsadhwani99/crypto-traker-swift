//
//  CoinRowView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
    let coin: Coin
    let isPortfolio: Bool
    
    init(coin: Coin, isPortfolio: Bool = false) {
        self.coin = coin
        self.isPortfolio = isPortfolio
    }
    
    var body: some View {
        HStack {
            // market cap rank
            Text("\(coin.marketCapRank)")
                .font(.caption)
                .foregroundColor(.gray)
            
            // image
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.orange)
            
            // coin name info
            coinNameInfoSection
            
            Spacer()
            
            // coin price info
            coinPriceSection
            
            // holdings info
            if isPortfolio {
                holdingsSection
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, isPortfolio: true)
    }
}

extension CoinRowView {
    private var holdingsSection: some View {
        VStack (alignment: .trailing, spacing: 4) {
            Text(coin.currentHoldingsValue.toCurrency())
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            
            Text((coin.currentHoldings ?? 0.00).asNumberString())
                .font(.caption)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.secondaryColor)
        }
        .padding(.leading, 2)
        .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
    }
    
    private var coinPriceSection: some View {
        VStack (alignment: .trailing, spacing: 4) {
            Text(coin.currentPrice.toCurrency())
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            
            Text(coin.priceChangePercentage24H.toPercentString())
                .font(.caption)
                .padding(.leading, 6)
                .foregroundColor(coin.priceChangePercentage24H > 0 ? Color.theme.green : Color.theme.red)
        }
        .padding(.leading, 2)
    }
    
    private var coinNameInfoSection: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(coin.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            
            Text(coin.symbol.uppercased())
                .font(.caption)
                .padding(.leading, 6)
        }
        .padding(.leading, 2)
    }
}
