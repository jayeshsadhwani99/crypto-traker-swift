//
//  HomeViewModel.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    let statistics: [Statistic] = [
        Statistic(title: "Title", value: "Value", percentageChange: 1),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value"),
        Statistic(title: "Title", value: "Value", percentageChange: -2)
    ]
    
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$topMovingCoins
            .sink { [weak self] (returnedCoins) in
                if (self?.searchText ?? "").isEmpty {
                    self?.topMovingCoins = returnedCoins
                }
            }
            .store(in: &cancellables)
        
        // updates coins
        $searchText
            .combineLatest(dataService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.coins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercaseText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercaseText) ||
            coin.symbol.lowercased().contains(lowercaseText) ||
            coin.id.lowercased().contains(lowercaseText)
        }
    }
}
