//
//  CoinViewModel.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 16/10/22.
//

import Foundation
import Combine
import SwiftUI

class CoinImageViewModel : ObservableObject {
    
    @Published var image : UIImage? = nil
    private var anyCancalbales : AnyCancellable?
    let imageService : ImageDownloaderService

    init(imagePath:String) {
        self.imageService =  ImageDownloaderService(networkRequest: NativeRequestable(), environment: .development, imagePath: imagePath)
        subscribeToImageService()
        
    }
    
    func subscribeToImageService() {
        
        anyCancalbales = imageService.$image.sink { completion in
                        switch completion {
                        case .failure(let error):
                            print("oops got an error \(error.localizedDescription)")
                        case .finished:
                            print("nothing much to do here")
                        }
                } receiveValue: { [weak self] image in
                    self?.image = image
                }
    }
}


