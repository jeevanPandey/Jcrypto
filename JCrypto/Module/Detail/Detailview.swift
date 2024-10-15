//
//  Detailview.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 12/10/24.
//

import SwiftUI


struct DetailLoadingView: View {
   @Binding var coin: CoinModel?
  init(coin: Binding <CoinModel?>) {
    self._coin = coin
  }
    var body: some View {
      ZStack {
        if let coin = self.coin {
          Detailview(coin: coin)
        }
      }
     
    }
}

struct Detailview: View {
  @StateObject private var detailViewModel: DetailViewModel
  private let gridItems: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  init(coin: CoinModel) {
    self._detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("")
        
        getViewFor(text: "Overview")
        Divider()
        getGridViewFor(stats: detailViewModel.overviewStatistics)
        
        Divider()
        getViewFor(text: "Additional Details")
        getGridViewFor(stats: detailViewModel.additionalStatistics)
      }
      .padding()
    }
    .navigationTitle(self.detailViewModel.coinModel.name)
  }
  
  private func getViewFor(text: String) -> some View {
    return Text(text)
              .font(.headline)
              .bold()
              .foregroundColor(Color.theme.AccentColor)
              .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private func getGridViewFor(stats: [Statistic]) -> some View {
    return LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10) {
      ForEach(detailViewModel.additionalStatistics) {  stats in
        StatisticView(staticData: stats)
      }
    }
  }
}

struct Detailview_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        Detailview(coin: dev.coin)
      }
    }
}
