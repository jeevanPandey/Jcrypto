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


class CoinDownloaderService : ObservableObject {
    
    var coinCancalble : AnyCancellable?
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
       
        coinCancalble =  self.downloadCoinData()
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

