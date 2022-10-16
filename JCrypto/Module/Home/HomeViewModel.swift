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
    let coinService : CoinDownloaderService
    
     init() {
        /* DispatchQueue.main.asyncAfter(deadline: .now()+1) {
             self.portfolioCoins.append(DeveloperPreview.instance.coin)
             self.liveCoins.append(DeveloperPreview.instance.coin)
         } */
         
         self.coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
         
         downloadCoinsData()
    }
    
    func downloadCoinsData() {
        
    anyCancalbales =  self.coinService.$liveCoins.sink { completion in
                        switch completion {
                        case .failure(let error):
                            print("oops got an error \(error.localizedDescription)")
                        case .finished:
                            print("nothing much to do here")
                        }
                    } receiveValue: { allCoins in
                        self.liveCoins = allCoins
                     }

        
    /*    let coinService = CoinDownloaderService(networkRequest: NativeRequestable(), environment: .development)
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
               
            } */
        
        
        
       
        
            
    }
}
