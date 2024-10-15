//
//  CoinDataDownloader.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 13/10/22.
//

import Foundation
import Combine


protocol CoinDataDownloader {
    func downloadCoinData() -> AnyPublisher<[CoinModel], NetworkError>
}


class CoinDownloaderService: CoinDataDownloader {
    var cancellables = Set<AnyCancellable>()
    private var networkRequest: Requestable
    private var environment: AppEnvironment = .development
    @Published var liveCoins = [CoinModel]()

     
  
   // inject this for testability
     init(networkRequest: Requestable, environment: AppEnvironment) {
         self.networkRequest = networkRequest
         self.environment = environment
         subscribeToCoinServices()
     }
    
    func subscribeToCoinServices() {
       
      self.downloadCoinData()
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    print("nothing much to do here")
                }
            } receiveValue: {[weak self ] (allCoins) in
                
                DispatchQueue.main.async {
                    self?.liveCoins = allCoins
                }
            }
            .store(in: &cancellables)
    }

     
    func downloadCoinData() -> AnyPublisher<[CoinModel], NetworkError> {
        let endPoint = AppEndPoints.getCoins
        let request = endPoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request, enableDecode: true)
    }
    
}


