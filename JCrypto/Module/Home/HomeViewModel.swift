//
//  HomeViewModel.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
  enum SortOption {
    case rank, rankReversed, holdings, holdingReversed, price, priceReversed
  }
  @Published var portfolioCoins = [CoinModel]()
  @Published var liveCoins = [CoinModel]()
  @Published var searchText = ""
  @Published var allStatsData = [Statistic]()
  @Published var isDataLoading = false
  @Published var sortOption: SortOption = .holdings
  
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
    getAllData()
  }
  
  func getAllData() {
    isDataLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.downloadCoinsData()
      self.downloadStatisticsData()
      self.getPortfioLocalData()
    }
  }
  
  public func refreshCoinsData() {
    self.downloadCoinsData()
    self.downloadStatisticsData()
  }
  
  func downloadCoinsData() {
    anyCancalbales = $searchText
      .combineLatest(self.coinService.$liveCoins, $sortOption)
      .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
      .map(filterAndSortCoin)
      .sink {  [weak self] allCoins in
        self?.liveCoins = allCoins
        self?.isDataLoading = false
      }
    
  }
  
  
  private func filterAndSortCoin(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
    var filteredCoins = filterCoin(text: text, coins: coins)
    sortCoins(coins: &filteredCoins, sortOption: sortOption)
    return filteredCoins
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
  
  private func sortCoins(coins: inout [CoinModel], sortOption: SortOption) {
    switch sortOption {
      case .rank, .holdings:
         coins.sort(by: { $0.rank < $1.rank })
      case .rankReversed, .holdingReversed:
         coins.sort(by: { $0.rank > $1.rank })
      case .price:
         coins.sort(by: { $0.currentPrice < $1.currentPrice })
      case .priceReversed:
         coins.sort(by: { $0.currentPrice > $1.currentPrice })
    }
  }
  
  private func sortPortfilioCoins(coins: [CoinModel]) -> [CoinModel] {
    switch sortOption {
      case .holdings:
        return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
      case .holdingReversed:
        return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
      default:
        return coins
    }
  }

  
  func downloadStatisticsData() {
    isDataLoading = true
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
      self?.isDataLoading = false
    }
  }
  
  func getPortfioLocalData() {
    $liveCoins.combineLatest(portfioLocalCacheService.$savedEntities).map { coinModels, portfolio -> [CoinModel] in
      coinModels.compactMap { eachCoin -> CoinModel? in
        guard let entity = portfolio.first(where: { eachFolio in
          return eachFolio.coinID == eachCoin.id
        }) else { return nil }
        return eachCoin.updateHoldings(amount: entity.amount)
      }
    }
    .sink { [weak self] allCoins in
      guard let self else { return }
      let updatedCoins = self.sortPortfilioCoins(coins: allCoins)
      self.portfolioCoins = updatedCoins
    }
    .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfioLocalCacheService.updatePortfolio(coin: coin, amount: amount)
  }
}

