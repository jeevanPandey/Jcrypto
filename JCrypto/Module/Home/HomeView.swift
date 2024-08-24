//
//  HomeView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    @State private var showPortfolioView = false

    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
      ZStack {
        Color.theme.BackgroundColor
          .ignoresSafeArea()
          .sheet(isPresented: $showPortfolioView) {
            EditPortfolio()
          }
        VStack(spacing: 20) {
          homeHeader
          HomeStatsView(showPortfolio: $showPortfolio)
          SearchBarView(searchText: $homeViewModel.searchText)
          columnView
          if(!showPortfolio) {
            coinView
              .transition(.move(edge: .leading))
            // .animation(Animation.easeInOut(duration: 0.0) , value: UUID())
            
          } else {
            portfolioView
              .transition(.move(edge: .leading))
          }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
      }
    }
}


extension HomeView {
    
  private var homeHeader: some View {
    return  HStack {
      CircleButtonView(iconName: showPortfolio ? "plus" : "info")
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          }
        }
        .animation(nil, value:  UUID())
      Spacer()
      Text(showPortfolio ? "Portfolio":"Live prices" )
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(.accentColor)
        .animation(nil, value: UUID())
      Spacer()
      CircleButtonView(iconName: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180:0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
      
    }
    .padding(.horizontal)
  }
}

extension HomeView {
  private var columnView: some View {
    return  HStack {
      Text("Coin")
      if(showPortfolio) {
        Text("Holdings")
          .frame(width: UIScreen.main.bounds.width/2.5,  alignment: .trailing)
      }
      Spacer()
      Text("Price")
    }
    .foregroundColor(Color.theme.SecondaryTextColor)
    .padding()
  }
}

extension HomeView {
  private var coinView: some View {
    List {
      ForEach(homeViewModel.liveCoins) { eachCoin in
        CoinRowView(coin: eachCoin, showHoldingColumn: false)
      }
    }
    .listStyle(.plain)
  }
  
  private var portfolioView: some View {
    List {
      ForEach(homeViewModel.portfolioCoins) { eachCoin in
        CoinRowView(coin: eachCoin, showHoldingColumn: true)
      }
    }
    .listStyle(.plain)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeVM)
  }
}


extension View {
    func printOutput(_ value: Any) -> Self {
        print(value)
        return self
    }
}
