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
    @Published var allStatsData = [stat1, stat2, stat3, stat4]
   
    private var anyCancalbales : AnyCancellable?
    let coinService : CoinDownloaderService
  //  let marketDataService : MarketDataService

    
     init() {
        /* DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             self.portfolioCoins.append(DeveloperPreview.instance.coin)
             self.liveCoins.append(DeveloperPreview.instance.coin)
         } */
         
         self.coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
       //  self.marketDataService = MarketDataService(networkRequest: NativeRequestable(), environment: .development)
         
         downloadCoinsData()
    }
    
    func downloadCoinsData() {
        
  /*  anyCancalbales =  self.coinService.$liveCoins.sink { completion in
                        switch completion {
                        case .failure(let error):
                            print("oops got an error \(error.localizedDescription)")
                        case .finished:
                            print("nothing much to do here")
                        }
                    } receiveValue: { allCoins in
                        self.liveCoins = allCoins
                     } */
      
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
 
  /*
  func downloadStatisticsData() {
    
    anyCancalbales =  self.marketDataService.$marketData.sink { completion in
      switch completion {
        case .failure(let error):
          print("oops got an error \(error.localizedDescription)")
        case .finished:
          print("nothing much to do here")
      }
    } receiveValue: { globalData in
      debugPrint("got the data \(globalData)")
      
    }
  } */

}

extension HomeViewModel {
  static let stat1 = Statistic(title: "Market Cap", value: "$12.5Bn", percentageChnage: 25.34)
  static let stat2 = Statistic(title: "Total Volume", value: "$1.23Tr")
  static let stat3 = Statistic(title: "My Value", value: "$98.4k", percentageChnage: 15.85)
  static let stat4 = Statistic(title: "Portfolio Value", value: "$50.4k", percentageChnage: -12.34)
}
