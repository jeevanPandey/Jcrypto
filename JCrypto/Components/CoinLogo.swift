//
//  CoinLogo.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 23/08/24.
//

import SwiftUI

struct CoinLogo: View {
  let coin: CoinModel
    var body: some View {
      VStack {
        CoinImageView(imagePath: coin.image)
          .frame(width: 50, height: 50)
        Text(coin.symbol)
          .font(.headline)
          .foregroundColor(Color.theme.AccentColor)
        Text(coin.name)
          .font(.callout)
          .foregroundColor(Color.theme.SecondaryTextColor)
          .lineLimit(2)
          .multilineTextAlignment(.center)
      }
      
    }
}

struct CoinLogo_Previews: PreviewProvider {
    static var previews: some View {
      CoinLogo(coin: dev.coin)
    }
}
