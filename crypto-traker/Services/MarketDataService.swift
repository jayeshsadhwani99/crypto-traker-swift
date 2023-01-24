//
//  MarketDataService.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    
    var marketDataSubscription:  AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        let urlString = "https://api.coingecko.com/api/v3/global"
        
        guard let url = URL(string: urlString) else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
