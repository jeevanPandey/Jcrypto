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
    private let cache: ImageCacheType
    private let otherCache =  NSCache<AnyObject, AnyObject>()


    let imaegPath: String
    @Published var image : UIImage?
    
    init(networkRequest: Requestable, environment: AppEnvironment,imagePath:String,cache: ImageCacheType = ImageCache()) {
        self.networkRequest = networkRequest
        self.environment = environment
        self.imaegPath = imagePath
        self.cache = cache
        subsribeToImage()
    }
    
    func subsribeToImage() {
        
        if let imageFromCache = otherCache.object(forKey: self.imaegPath as AnyObject) as? UIImage{
                    self.image = imageFromCache
                    return
            
        }
       
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
                if let pimage = recieveImage, let self = self {
                    self.otherCache.setObject(pimage, forKey: self.imaegPath as AnyObject)
                }
               
            })
            
    }
    
    func downloadImageData() -> AnyPublisher<Data, NetworkError> {
        let endPoint = AppEndPoints.getImage(imagePath: self.imaegPath)
        let request = endPoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request, enableDecode: false)
    }

}
