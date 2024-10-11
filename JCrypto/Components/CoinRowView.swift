//
//  CoinRowView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 12/10/22.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingColumn : Bool
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            leftView
            Spacer()
            if(showHoldingColumn) {
                centerView
            }
            rightView
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        CoinRowView(coin: dev.coin, showHoldingColumn: true)
            .previewLayout(.sizeThatFits)
    }
}

extension CoinRowView {
    private var leftView : some View {
        HStack() {
            Text("\(coin.rank)")
                .font(.headline)
                .foregroundColor(Color.theme.AccentColor)
                .frame(minWidth: 20)
            CoinImageView(imagePath: coin.image)
                .frame(width: 30, height: 30)
           
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.AccentColor)
        }
       
    }
    
    private var centerView : some View {
        VStack(alignment: .leading) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString() )
        }
        .padding(.trailing, 40.0)
    }
    
    private var rightView: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .bold()
                .foregroundColor(Color.theme.AccentColor)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "" )
                .foregroundColor((coin.priceChangePercentage24HInCurrency ?? 0) <= 0 ? Color.theme.RedColor : Color.theme.GreenColor)
        }
        .frame(width: UIScreen.main.bounds.width/3.5,  alignment: .trailing)
    }
}
