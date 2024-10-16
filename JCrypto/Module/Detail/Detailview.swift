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
  @State private var shouldExpandText = false
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
          if let description = detailViewModel.description {
            getDescriptionView(for: description)
          }
          getGridViewFor(stats: detailViewModel.overviewStatistics)
          Divider()
          getViewFor(text: "Additional Details")
          getGridViewFor(stats: detailViewModel.additionalStatistics)
        }
        ZStack(alignment: .leading) {
          HStack(spacing: 10) {
            if let website = detailViewModel.website,
               let websiteURL = URL(string: website) {
                Link("Website", destination: websiteURL)
            }
            
            if let redddit = detailViewModel.reddditwebsite,
               let redditURL = URL(string: redddit) {
                Link("Rdddit", destination: redditURL)
            }
          }
          .accentColor(.blue)
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
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
  
  private func getDescriptionView(for description: String) -> some View {
    VStack(alignment: .leading) {
      Text(description)
        .font(.headline)
        .foregroundColor(Color.theme.SecondaryTextColor)
        .lineLimit(shouldExpandText ? nil : 4)
      Button {
        withAnimation(.default) {
          shouldExpandText.toggle()
        }
      } label: {
        Text(shouldExpandText ? "Show Less" : "Show more")
          .font(.headline)
          .foregroundColor(Color.blue)
          .padding(.vertical, 6)
      }
    }
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
