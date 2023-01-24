//
//  HomeViewModel.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
     
    @Published var statistics: [Statistic] = []
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        coinDataService.$topMovingCoins
            .sink { [weak self] (returnedCoins) in
                if (self?.searchText ?? "").isEmpty {
                    self?.topMovingCoins = returnedCoins
                }
            }
            .store(in: &cancellables)
        
        // updates coins
        $searchText
            .combineLatest(coinDataService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.coins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $coins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
    private func mapAllCoinsToPortfolioCoins(coins: [Coin], portfolios: [Portfolio]) -> [Coin] {
        coins
            .compactMap { coin -> Coin? in
                guard let entity = portfolios.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    
    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let bitcoinDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
            
        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portfolioCoins
                .map { coin -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H / 100
                    
                    let previousValue = currentValue / (1 + percentChange)
                    
                    return previousValue
                }
                .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.toCurrency(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            bitcoinDominance,
            portfolio
        ])
        
        return stats;
    }
}
