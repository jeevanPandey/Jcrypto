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
  @State private var showDetail = false
  @State private var selecetedCoin: CoinModel? = nil
  
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
      if homeViewModel.isDataLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .gray))
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      }
    }
    .background(
      NavigationLink(destination: DetailLoadingView(coin: $selecetedCoin), isActive: $showDetail, label: {
        EmptyView()
      })
      
    )
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
      HStack(spacing: 10) {
        Text("Coin")
        Image(systemName: "chevron.down")
          .opacity((homeViewModel.sortOption == .rank || homeViewModel.sortOption == .rankReversed) ? 1 : 0)
          .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankReversed : .rank
        }
      }
      if(showPortfolio) {
        HStack(spacing: 10) {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity((homeViewModel.sortOption == .holdings || homeViewModel.sortOption == .holdingReversed) ? 1 : 0)
            .rotationEffect(Angle(degrees: homeViewModel.sortOption == .holdings ? 0 : 180))
        }
        .frame(width: UIScreen.main.bounds.width/2.5,  alignment: .trailing)
        .onTapGesture {
          withAnimation(.default) {
            homeViewModel.sortOption = homeViewModel.sortOption == .holdings ? .holdingReversed : .holdings
          }
        }
        
      }
      Spacer()
      HStack(spacing: 10) {
        Text("Price")
        Image(systemName: "chevron.down")
          .opacity((homeViewModel.sortOption == .price || homeViewModel.sortOption == .priceReversed) ? 1 : 0)
          .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
        }
      }
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
          .onTapGesture {
            segue(coin: eachCoin)
          }
      }
    }
    .listStyle(.plain)
    .refreshable {
      homeViewModel.refreshCoinsData()
    }
  }
  
  private var portfolioView: some View {
    List {
      ForEach(homeViewModel.portfolioCoins) { eachCoin in
        CoinRowView(coin: eachCoin, showHoldingColumn: true)
          .onTapGesture {
            segue(coin: eachCoin)
          }
      }
    }
    .listStyle(.plain)
    .refreshable {
      homeViewModel.refreshCoinsData()
    }
  }
  
  private func segue(coin: CoinModel) {
    selecetedCoin = coin
    showDetail.toggle()
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
