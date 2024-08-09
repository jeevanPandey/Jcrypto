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
            return "https://api.coingecko.com/api/v3"
        }
    }
    // https://api.coingecko.com/api/v3/global
    var imagebaseURL: String {
        switch self {
        case .development:
            return "https://assets.coingecko.com/coins/images"
        }
    }
}

public typealias Headers = [String: String]

// if you wish you can have multiple services like this in a project
enum AppEndPoints {
    case getCoins
    case getImage(imagePath: String)
    case getGobalData
    var requestTimeOut: Int {
        return 20
    }
    
  var path: String {
    switch self {
      case .getCoins:
        return "/coins//markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
      case .getImage(let imagePath):
        return imagePath
      case .getGobalData:
        return "/global"
    }
  }
  //specify the type of HTTP request
    var httpMethod: HTTPMethod {
        switch self {
          case .getCoins, .getImage(imagePath: ), .getGobalData:
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
          case .getCoins, .getGobalData :
            return baseUrl + path
        case .getImage(let _) :
            return "\(environment.imagebaseURL)/\(path)"
        }
        
    }
}

