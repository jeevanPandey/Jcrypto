//
//  HomeView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            homeHeader
            HStack {
                Text("Coin")
                if(showPortfolio){
                    Text("Holdings")
                        .frame(width: UIScreen.main.bounds.width/2.5,  alignment: .trailing)
                }
                Spacer()
                Text("Price")
            }
            .foregroundColor(Color.theme.SecondaryTextColor)
            .padding()
            
           if(!showPortfolio) {
                List {
                    ForEach(homeViewModel.portfolioCoins) { eachCoin in
                        CoinRowView(coin: eachCoin, showHoldingColumn: true)
                    }
                   
                }
                .listStyle(.plain)
                .transition(.move(edge: .leading))
               // .animation(Animation.easeInOut(duration: 0.0) , value: UUID())

            } else {
                List {
                    ForEach(homeViewModel.liveCoins) { eachCoin in
                        CoinRowView(coin: eachCoin, showHoldingColumn: false)
                    }
                   
                }
                .listStyle(.plain)
                .transition(.move(edge: .leading))
            } 
           
               
           }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
}


extension HomeView {
    
    private var homeHeader: some View {
       return  HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: UUID())
                .background(CircleanimationView(shouldAnimate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Show potfolio":"Live prices" )
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.accentColor)
                .animation(nil, value: UUID())
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 0:180))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                    
                }
            
        }
        .padding(.horizontal)
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
