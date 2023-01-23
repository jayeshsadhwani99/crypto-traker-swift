//
//  HomeViewModel.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    @Published var portfolioCoins: [Coin] = []
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$coins
            .sink { [weak self] (returnedCoins) in
                self?.coins = returnedCoins
            }
            .store(in: &cancellables)
        
        dataService.$topMovingCoins
            .sink { [weak self] (returnedCoins) in
                self?.topMovingCoins = returnedCoins
            }
            .store(in: &cancellables)

    }
}
