//
//  CoinServiceEndPoint.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 13/10/22.
//


/*
 
 https://udaypatial.medium.com/writing-a-generic-reusable-networking-layer-using-combine-swift-ios-fe8e16404a13
 */
import Foundation
import CoreVideo

public enum AppEnvironment: String, CaseIterable {
    case development
  //  case staging
   // case production
}

extension AppEnvironment {
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.coingecko.com/api/v3/coins/"
        }
    }
    
    var imagebaseURL: String {
        switch self {
        case .development:
            return "https://assets.coingecko.com/coins/images/1/large"
        }
    }
}

public typealias Headers = [String: String]

// if you wish you can have multiple services like this in a project
enum AppEndPoints {
    case getCoins
    
    case getImage(imagePath: String)

    
    var requestTimeOut: Int {
        return 20
    }
    
  //specify the type of HTTP request
    var httpMethod: HTTPMethod {
        switch self {
        case .getCoins, .getImage(imagePath: )  :
            return .GET
        }
    }
    
  // compose the NetworkRequest
    func createRequest(environment: AppEnvironment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
      //  headers["Authorization"] = "Bearer \(token)"
        return NetworkRequest(url: getURL(from: environment), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
  // encodable request body for POST
    var requestBody: Encodable? {
        return nil
    }
    
  // compose urls for each request
    func getURL(from environment: AppEnvironment) -> String {
        let baseUrl = environment.baseURL
        switch self {
        case .getCoins :
            return "\(baseUrl)/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        
        case .getImage(let imagePath) :
            return "\(environment.imagebaseURL)/\(imagePath)"
        }
        
    }
}



