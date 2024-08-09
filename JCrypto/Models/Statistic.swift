//
//  Statistic.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 04/08/24.
//

import Foundation

struct Statistic: Identifiable {
  let id = UUID().uuidString
  let title: String
  let value: String
  let percentageChnage: Double?
  internal init(title: String, value: String, percentageChnage: Double? = nil) {
    self.value = value
    self.title = title
    self.percentageChnage = percentageChnage
  }  
}
