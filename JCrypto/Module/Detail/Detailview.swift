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
      VStack {
        ChartView(coin: detailViewModel.coinModel)
          .padding(.vertical)
        VStack(spacing: 20) {
          getViewFor(text: "Overview")
          Divider()
          getGridViewFor(stats: detailViewModel.overviewStatistics)
          
          Divider()
          getViewFor(text: "Additional Details")
          getGridViewFor(stats: detailViewModel.additionalStatistics)
        }
      }
      .padding()
    }
    .navigationTitle(self.detailViewModel.coinModel.name)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        coinRightIcon
      }
    }
  }
  
  private func getViewFor(text: String) -> some View {
            Text(text)
              .font(.headline)
              .bold()
              .foregroundColor(Color.theme.AccentColor)
              .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private func getGridViewFor(stats: [Statistic]) -> some View {
     LazyVGrid(columns: gridItems,
                     alignment: .leading, spacing: 30) {
      ForEach(stats) { stats in
        StatisticView(staticData: stats)
      }
    }
  }
  
}


extension Detailview {
  private var coinRightIcon: some View {
    HStack {
      Text(detailViewModel.coinModel.name)
        .font(.callout)
        .foregroundColor(Color.theme.SecondaryTextColor)
      CoinImageView(imagePath: detailViewModel.coinModel.image)
        .frame(width: 25, height: 25)
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
