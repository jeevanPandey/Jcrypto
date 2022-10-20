//
//  ImageDownloaderService.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 16/10/22.
//

import Foundation
import Combine
import SwiftUI

class ImageDownloaderService : ObservableObject {
    var cancalableTask : AnyCancellable?
    private var networkRequest : Requestable
    private var environment: AppEnvironment = .development
    let imaegPath: String
    @Published var image : UIImage?
    
    init(networkRequest: Requestable, environment: AppEnvironment,imagePath:String) {
        self.networkRequest = networkRequest
        self.environment = environment
        self.imaegPath = imagePath
        subsribeToImage()
    }
    
    func subsribeToImage() {
        cancalableTask = self.downloadImageData().tryMap({ (data) -> UIImage? in
            return UIImage(data: data)
        })
            .receive(on: RunLoop.main, options: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("oops got an error \(error.localizedDescription)")
                case .finished:
                    print("nothing much to do here")
                }
            }, receiveValue: {[weak self] recieveImage in
                self?.image = recieveImage
            })
            
    }
    
    func downloadImageData() -> AnyPublisher<Data, NetworkError> {
        let endPoint = AppEndPoints.getImage(imagePath: self.imaegPath)
        let request = endPoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request, enableDecode: false)
    }

}
