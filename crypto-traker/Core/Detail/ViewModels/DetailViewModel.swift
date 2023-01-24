//
//  DetailViewModel.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { returnedCoinDetails in
                print("DEBUG: Recieved coin data")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
