//
//  HomeViewModel.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
  @Published var portfolioCoins = [CoinModel]()
  @Published var liveCoins = [CoinModel]()
  @Published var searchText = ""
  @Published var allStatsData = [Statistic]()
  
  private var anyCancalbales : AnyCancellable?
  private var marketCancalble : AnyCancellable?
  private var portfilioCancalble : AnyCancellable?
  var cancellables = Set<AnyCancellable>()
  
  let coinService : CoinDownloaderService
  let marketDataService : MarketDataService
  let portfioLocalCacheService: PortfolioDataService
  
  init() {
    self.coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
    self.marketDataService = MarketDataService(networkRequest: NativeRequestable(), environment: .development)
    self.portfioLocalCacheService = PortfolioDataService()
    downloadCoinsData()
    downloadStatisticsData()
    getPortfioLocalData()
  }
  
  func downloadCoinsData() {
    anyCancalbales = $searchText
      .combineLatest(self.coinService.$liveCoins)
      .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
      .map(filterCoin)
      .sink {  [weak self] allCoins in
        self?.liveCoins = allCoins
      }
    
  }
  
  private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !searchText.isEmpty else {
      return coins
    }
    let lowercasedText = searchText.lowercased()
    return coins.filter { coin in
      return coin.name.lowercased().contains(lowercasedText) ||
      coin.id.lowercased().contains(lowercasedText) ||
      coin.symbol.lowercased().contains(lowercasedText)
    }
  }
  
  func downloadStatisticsData() {
    
   marketCancalble = self.marketDataService.$marketData
      .combineLatest($portfolioCoins) { (globalData, portfioData) -> [Statistic] in
      var stats = [Statistic]()
      guard let data = globalData?.data else {
        return stats
      }
      let marketCap = Statistic(title: "Market Cap",
                                value: data.marketCap,
                                percentageChnage: data.marketCapChangePercentage24HUsd)
      let volume = Statistic(title: "Volume", value: data.volume)
      let btcDominanace = Statistic(title: "BTC\n Dominance", value: data.btcDominance)
      let portfioValue = portfioData.map({$0.currentHoldingsValue}).reduce(0, { $0 + $1 })
      let previousValue = portfioData.map { (coin) -> Double in
          let currentValue = coin.currentHoldingsValue
          let percentChange = coin.priceChangePercentage24H ?? 0 / 100
          let previousValue = currentValue / (1 + percentChange)
          return previousValue
        }
          .reduce(0, +)
     let percentageChange = ((portfioValue - previousValue) / previousValue)

     let portfolio = Statistic(title: "Portfolio",
                                value: portfioValue.asCurrencyWith2Decimals(),
                                percentageChnage: percentageChange)
        
      stats.append(contentsOf: [marketCap,
                                volume,
                                btcDominanace,
                                portfolio])
      return stats
    }
    .sink { [weak self] stats in
      self?.allStatsData = stats
    }
  }
  
  func getPortfioLocalData() {
    $liveCoins.combineLatest(portfioLocalCacheService.$savedEntities).map { coinModels, portfolio -> [CoinModel] in
      coinModels.compactMap { eachCoin -> CoinModel? in
        debugPrint("\(eachCoin.id)")
        guard let entity = portfolio.first(where: { eachFolio in
          return eachFolio.coinID == eachCoin.id
        }) else { return nil }
        return eachCoin.updateHoldings(amount: entity.amount)
      }
    }
    .sink { [weak self] allCoins in
      self?.portfolioCoins = allCoins
    }
    .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfioLocalCacheService.updatePortfolio(coin: coin, amount: amount)
  }
}

