//
//  CoinDeatilService.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 12/10/24.
//

import Foundation
import Combine


protocol CoinDetailDataiDownloader {
  func downloadCoinDetailData() -> AnyPublisher<CoinDetailModel, NetworkError>
}


class CoinDetailDownloaderService: CoinDetailDataiDownloader {
  var cancelable : AnyCancellable?
  private var networkRequest: Requestable
  private var environment: AppEnvironment = .development
  private let coinID: String
  @Published var coinData: CoinDetailModel? = nil
  
  // inject this for testability
  init(networkRequest: Requestable, environment: AppEnvironment, coinID: String) {
    self.networkRequest = networkRequest
    self.environment = environment
    self.coinID = coinID
    subscribeToCoinServices()
  }
  
  func subscribeToCoinServices() {
    cancelable = self.downloadCoinDetailData()
      .sink(receiveCompletion: { error in
        debugPrint("Error \(error)")
      }, receiveValue: { coinDetail in
        debugPrint("Found Detail \(coinDetail)")
        self.coinData = coinDetail
      })
  }
  
  func downloadCoinDetailData() -> AnyPublisher<CoinDetailModel, NetworkError> {
    let endPoint = AppEndPoints.getCoinDeati(coinID: self.coinID)
    let request = endPoint.createRequest(environment: self.environment)
    return self.networkRequest.request(request, enableDecode: true)
  }
}
