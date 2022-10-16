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
   
    private var anyCancalbales : AnyCancellable?
    
     init() {
        /* DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             self.portfolioCoins.append(DeveloperPreview.instance.coin)
             self.liveCoins.append(DeveloperPreview.instance.coin)
         } */
         
         subscribeToCoinServices()
    }
    
    func subscribeToCoinServices() {
        
        let coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
        anyCancalbales =  coinService.downloadCoinData()
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
            
        //        coinService.$allCoins.sink { [weak self] allCoins in
        //            self?.liveCoins = allCoins
        //        }
        //        .store(in: &anyCancalbales)
        
    }
}
