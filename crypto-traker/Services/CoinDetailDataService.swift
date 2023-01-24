//
//  CoinDetailDataService.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetail? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin: Coin) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        
        guard let url = URL(string: urlString) else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
