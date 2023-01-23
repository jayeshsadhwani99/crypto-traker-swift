//
//  CoinDataService.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import Combine

class CoinDataService {
    @Published var coins: [Coin] = []
    @Published var topMovingCoins = [Coin]()
    
    var coinSubscription: AnyCancellable?
    
    init() {
        fetchCoinData()
    }
    
    func fetchCoinData() {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.coins = returnedCoins
                self?.configTopMovingCoins()
                self?.coinSubscription?.cancel()
            })
    }
    
    func configTopMovingCoins() {
        let topMovers = coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
        self.topMovingCoins = Array(topMovers.prefix(5))
    }
}
