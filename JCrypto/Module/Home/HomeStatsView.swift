//
//  HomeStatsView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 04/08/24.
//

import SwiftUI

struct HomeStatsView: View {
  @Binding var showPortfolio: Bool
  @EnvironmentObject private var homeViewModel: HomeViewModel
    var body: some View {
      HStack {
        ForEach(homeViewModel.allStatsData) { data in
          StatisticView(staticData: data)
            .frame(width: UIScreen.main.bounds.width/3)
        }
      }
      .frame(width: UIScreen.main.bounds.width,
             alignment: !showPortfolio ? .leading : .trailing)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
      HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(dev.homeVM)
    }
}
