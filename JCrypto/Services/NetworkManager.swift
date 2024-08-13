//
//  NetworkManager.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 13/10/22.
//

import Foundation
import Combine
import UIKit

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest,enableDecode:Bool) -> AnyPublisher<T, NetworkError>
}

/* extension NativeRequestable {
 
 func request<T: Codable>(_ req: NetworkRequest,enableDecode:Bool = true) -> AnyPublisher<T, NetworkError> {
 return request(req, enableDecode: enableDecode)
 }
 } */


public class NativeRequestable: Requestable {
    
    
    public var requestTimeOut: Float = 30
    
 public func request<T>(_ req: NetworkRequest,enableDecode :Bool) -> AnyPublisher<T, NetworkError>
    where T: Decodable, T: Encodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        
        guard let url = URL(string: req.url) else {
            // Return a fail publisher if the url is invalid
            return AnyPublisher(
                Fail<T, NetworkError>(error: NetworkError.badURL("Invalid Url"))
            )
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ response -> T in
                guard response.response is HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, error: "Server error")
                }
                if(!enableDecode) {
                    return response.data as! T
                }
                let decoder = JSONDecoder()
                do {
                  let loginResponse = try decoder.decode(T.self, from: response.data)
                  return loginResponse
                } catch {
                  debugPrint("Error is \(error)")
                  throw NetworkError.serverError(code: 0, error: "Server error")
                }
            }
            .mapError({ error -> NetworkError in
              print("req \(req.url)")
                return NetworkError.serverError(code: 0, error: "Server error")
            })
            .eraseToAnyPublisher()
    }
    
 public func request1<T>(_ req: NetworkRequest,enableDecode:Bool) -> AnyPublisher<T, NetworkError>
        where T: Decodable, T: Encodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        
        guard let url = URL(string: req.url) else {
            // Return a fail publisher if the url is invalid
            return AnyPublisher(
                Fail<T, NetworkError>(error: NetworkError.badURL("Invalid Url"))
            )
        }
        if (!enableDecode) {
            debugPrint("url is \(req.url)")
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { output in
                    // throw an error if response is nil
                    guard output.response is HTTPURLResponse else {
                        throw NetworkError.serverError(code: 0, error: "Server error")
                    }
                    return output.data as! T
                }
                .mapError { error in
                    NetworkError.invalidJSON(String(describing: error))
                }
                .eraseToAnyPublisher()
            
        } else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { output in
                    // throw an error if response is nil
                    guard output.response is HTTPURLResponse else {
                        throw NetworkError.serverError(code: 0, error: "Server error")
                    }
                    return output.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    // return error if json decoding fails
                    NetworkError.invalidJSON(String(describing: error))
                }
                .eraseToAnyPublisher()
        }
        // We use the dataTaskPublisher from the URLSession which gives us a publisher to play around with.
        
    }
    
    
}
