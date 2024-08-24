//
//  PortfolioView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 17/08/24.
//

import SwiftUI

struct EditPortfolio: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject private var vm: HomeViewModel
  @State private var selectedCoin: CoinModel?
  @State private var portfolioAmount = ""
  @State private var totalPrice = 0.0
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading,spacing: 10) {
          SearchBarView(searchText: $vm.searchText)
          LogoList
          if let selectedCoin = selectedCoin {
            createUIFrom(selectedCoin)
          }
        }
      }
      .navigationTitle("My portfolio")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
        XmarkButton(dismiss: _dismiss)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            debugPrint("Item saved")
            portfolioAmount = ""
            totalPrice = 0
          }
          .opacity(totalPrice > 0 ? 1.0 : 0)
        }
        
      }
    }
  }
  
  fileprivate func getPriceView(selectedCoin: CoinModel) -> some View {
    return HStack {
      Text("Current price of \(selectedCoin.symbol.uppercased()): ")
      Spacer()
      Text("\(selectedCoin.currentPrice.asCurrencyWith2Decimals())")
    }
  }
  
  fileprivate func getAmountTextFieldView(selectedCoin: CoinModel) -> some View {
    return HStack {
      Text("Amount in wallet")
      Spacer()
      TextField("Enter amount", text: $portfolioAmount)
        .keyboardType(.decimalPad)
        .onChange(of: portfolioAmount) { newValue in
          
          let filtered = newValue.filter { "0123456789.".contains($0) }
          let components = filtered.split(separator: ".")
          if components.count > 2 {
            portfolioAmount = String(components[0]) + "." + components.dropFirst().joined()
          } else {
            portfolioAmount = filtered
          }
          if let amount = Double(portfolioAmount) {
            totalPrice = amount * (selectedCoin.currentPrice)
          }
        }
        .multilineTextAlignment(.trailing)
    }
  }
  
  fileprivate func getFinalPriceView() -> some View {
    return VStack {
      Divider()
      HStack {
        Text("Current value: ")
        Spacer()
        Text("\(totalPrice.asCurrencyWith2Decimals())")
      }
    }
  }
  
  fileprivate func createUIFrom(_ selectedCoin: CoinModel) -> some View {
    return VStack {
      getPriceView(selectedCoin: selectedCoin)
      Divider()
      getAmountTextFieldView(selectedCoin: selectedCoin)
      if totalPrice > 0 {
        getFinalPriceView()
      }
    }
    .padding()
  }

}


extension EditPortfolio {
  private var LogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack {
        ForEach(vm.liveCoins) { coin in
          CoinLogo(coin: coin)
            .frame(width: 75)
            .padding(10)
            .onTapGesture {
              selectedCoin = coin
              portfolioAmount = ""
              totalPrice = 0
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selectedCoin?.id == coin.id ? Color.theme.GreenColor : Color.clear, lineWidth: 1)
            )
        }
      }
      .padding(.vertical, 10)
      .padding(.leading)
    }
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    EditPortfolio()
      .environmentObject(dev.homeVM)
  }
}
