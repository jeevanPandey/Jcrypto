//
//  SettingScreen.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 17/10/24.
//

import SwiftUI

struct SettingScreen: View {
  @Environment(\.dismiss) var dismiss
  let githubURL = URL(string: "https://github.com/freeCodeCamp/freeCodeCamp")!
  let coinGeko = URL(string: "https://www.coingecko.com/")!
  let youtubeLink = URL(string: "https://www.youtube.com/@SwiftfulThinking")!
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          VStack(alignment: .leading) {
            Image("logo-transparent")
            Text("App was created using MVVM pattern with help of combine. Application is created USING SwifUI. The coin data was displayed using Free API `coingecko.com`")
              .font(.headline)
              .foregroundColor(Color.theme.SecondaryTextColor)
            Link("Visit github", destination: githubURL)
              .padding(.vertical)
              .accentColor(.blue)
          }
        } header: {
          Text("App info")
            .foregroundColor(Color.theme.GreenColor)
        }
        
        Section {
          VStack(alignment: .leading) {
            Image("coingecko")
              .resizable()
              .scaledToFit()
              .frame(height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("CoinGecko provides a fundamental analysis of the digital currency market. In addition to tracking price, volume, and market capitalization, CoinGecko tracks community growth, open source code development, major events, and on-chain metrics")
              .font(.headline)
              .foregroundColor(Color.theme.SecondaryTextColor)
            Link("Visit the coin geko website", destination: coinGeko)
              .padding(.vertical)
              .accentColor(.blue)
          }
        } header: {
          Text("Coin Geko")
            .foregroundColor(Color.theme.GreenColor)
        }
        
        Section {
          VStack(alignment: .leading) {
            Image("youtubeLogo")
              .scaledToFit()
              .padding(.trailing)
            Text("I have learned this from very awesome youtube channel, channel admin name is Nick. Request you to subscribe to his you tube channel and learn a lot !")
              .font(.callout)
              .foregroundColor(Color.theme.SecondaryTextColor)
            Link("Check out the videos", destination: youtubeLink)
              .padding(.vertical)
              .accentColor(Color.theme.RedColor)
          }
        } header: {
          Text("About the learning resource")
            .foregroundColor(Color.theme.GreenColor)
        }
        
      }
      .navigationTitle("About screen")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XmarkButton(dismiss: _dismiss)
        }
      }
    }
  }
}

struct SettingScreen_Previews: PreviewProvider {
  static var previews: some View {
    SettingScreen()
  }
}
