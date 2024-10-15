//
//  DetailViewModel.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 12/10/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  var cancellables = Set<AnyCancellable>()
  let coinDetailservice : CoinDetailDownloaderService
  @Published var coinDetail: CoinDetailModel?
  @Published var coinModel: CoinModel
  @Published var overviewStatistics: [Statistic] = []
  @Published var additionalStatistics: [Statistic] = []
  
  init(coin: CoinModel) {
    self.coinModel = coin
    self.coinDetailservice = CoinDetailDownloaderService(networkRequest: NativeRequestable(),
                                                         environment: .development,
                                                         coinID: coin.id)
    downloadCoinDetail()
  }
  
  private func downloadCoinDetail() {
   coinDetailservice.$coinData
      .combineLatest($coinModel)
      .receive(on: DispatchQueue.main)
      .map(mapDataToStatistics)
      .sink { completion in
      switch completion {
        case .failure(let error):
          print("oops got an error while Downloading Coin Deatils \(error.localizedDescription)")
        case .finished:
          print("downloaded Coin Details")
      }
    } receiveValue: { [weak self] coinDetail in
      self?.overviewStatistics = coinDetail.overview
      self?.additionalStatistics = coinDetail.additional
    }
    .store(in: &cancellables)
  }
  
  private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [Statistic], additional: [Statistic]) {
          let overviewArray = createOverviewArray(coinModel: coinModel)
          let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
          return (overviewArray, additionalArray)
      }
      
      private func createOverviewArray(coinModel: CoinModel) -> [Statistic] {
          let price = coinModel.currentPrice.asCurrencyWith6Decimals()
          let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChnage: pricePercentChange)
          
          let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
          let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChnage: marketCapPercentChange)
          
          let rank = "\(coinModel.rank)"
          let rankStat = Statistic(title: "Rank", value: rank)
          
          let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
          let volumeStat = Statistic(title: "Volume", value: volume)
          
          let overviewArray: [Statistic] = [
              priceStat, marketCapStat, rankStat, volumeStat
          ]
          return overviewArray
      }
      
      private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [Statistic] {
          
          let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
          let highStat = Statistic(title: "24h High", value: high)
          
          let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
          let lowStat = Statistic(title: "24h Low", value: low)
          
          let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
          let pricePercentChange = coinModel.priceChangePercentage24H
          let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChnage: pricePercentChange)
          
          let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
          let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChnage: marketCapPercentChange)
          
          let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
          let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
          let blockStat = Statistic(title: "Block Time", value: blockTimeString)
          
          let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
          let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
          
          let additionalArray: [Statistic] = [
              highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
          ]
          return additionalArray
      }
  
}

