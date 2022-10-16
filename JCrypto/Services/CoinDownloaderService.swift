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

struct URLPath {
    static let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
}

class CoinDownloaderService : CoinDataDownloader {
    
    var coinCancalble : AnyCancellable?
    private var networkRequest: Requestable
     private var environment: AppEnvironment = .development
     
  
   // inject this for testability
     init(networkRequest: Requestable, environment: AppEnvironment) {
         self.networkRequest = networkRequest
         self.environment = environment
     }

     
    func downloadCoinData() -> AnyPublisher<[CoinModel], NetworkError> {
        let endPoint = AppEndPoints.getCoins
        let request = endPoint.createRequest(environment: self.environment)
        
        return self.networkRequest.request(request)
    }
    
}




/*
 
 private func downloadCoins() {
     
     guard let URL = URL(string: URLPath.baseURL) else {
         return
     }
     
    coinCancalble =  URLSession.shared.dataTaskPublisher(for: URL)
         .subscribe(on: DispatchQueue.global(qos: .background), options: .none)
         .tryMap { output -> Data in
             guard let response = output.response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
                 throw URLError(URLError.badServerResponse)
             }
             return output.data
         }
         .receive(on: DispatchQueue.main, options: .none)
         .decode(type: [CoinModel].self, decoder: JSONDecoder())
         .sink { completion in
             switch completion {
             case .finished :
                 break
             case .failure(let error) :
                 print(error.localizedDescription)
             }
         } receiveValue: { [weak self] coins in
           //  self?.allCoins = coins
             self?.coinCancalble?.cancel()
         }
 }
 */

