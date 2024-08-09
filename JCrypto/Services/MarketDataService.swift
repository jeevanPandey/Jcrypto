//
//  MarketDataService.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 09/08/24.
//

import Foundation

import Foundation
import Combine


protocol MarketDataServiceDownloader {
    func downloadMarketData() -> AnyPublisher<GlobalData, NetworkError>
}


class MarketDataService : ObservableObject {
    
    var cancelable : AnyCancellable?
    private var networkRequest: Requestable
    private var environment: AppEnvironment = .development
  @Published var marketData: GlobalData?

     
   // inject this for testability
     init(networkRequest: Requestable, environment: AppEnvironment) {
         self.networkRequest = networkRequest
         self.environment = environment
       subscribeToService()
     }
    
    func subscribeToService() {
       
      cancelable =  self.downloadMarketData()
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    print("nothing much to do here")
                }
            } receiveValue: {[weak self ] (allData) in
                
                DispatchQueue.main.async {
                  self?.marketData = allData
                }
               
            }
    }

     
    func downloadMarketData() -> AnyPublisher<GlobalData, NetworkError> {
        let endPoint = AppEndPoints.getGobalData
        let request = endPoint.createRequest(environment: self.environment)
        
        return self.networkRequest.request(request, enableDecode: true)
    }
    
}
