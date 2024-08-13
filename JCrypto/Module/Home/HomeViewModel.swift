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

    let coinService : CoinDownloaderService
    let marketDataService : MarketDataService

    
     init() {
        /* DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             self.portfolioCoins.append(DeveloperPreview.instance.coin)
             self.liveCoins.append(DeveloperPreview.instance.coin)
         } */
         
        self.coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
        self.marketDataService = MarketDataService(networkRequest: NativeRequestable(), environment: .development)
         
        downloadCoinsData()
        downloadStatisticsData()
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
    
    marketCancalble = self.marketDataService.$marketData.map{ globalData -> [Statistic] in
      var stats = [Statistic]()
      guard let data = globalData?.data else {
        return stats
      }
      let marketCap = Statistic(title: "Market Cap",
                                value: data.marketCap,
                                percentageChnage: data.marketCapChangePercentage24HUsd)
      let volume = Statistic(title: "Volume", value: data.volume)
      let btcDominanace = Statistic(title: "BTC Dominance", value: data.btcDominance)
      let portfolio = Statistic(title: "Portfolio", value: "$0.0", percentageChnage: 0)
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
}

