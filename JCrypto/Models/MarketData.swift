//
//  MarketData.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 09/08/24.
//

import Foundation

struct GlobalData: Codable {
    let data: MarketData
}

// MARK: - DateClass
struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
  
  var marketCap: String {
    guard let item = totalMarketCap.first(where: {$0.key == "usd"}) else {
      return ""
    }
    return "\(item.value.formattedWithAbbreviations())"
  }
  
  var volume: String {
    guard let item = totalVolume.first(where: {$0.key == "usd"}) else {
      return ""
    }
    return "\(item.value.formattedWithAbbreviations())"
  }
  
  var btcDominance: String {
    guard let item = marketCapPercentage.first(where: {$0.key == "btc"}) else {
      return ""
    }
    return item.value.asPercentString()
  }
}
