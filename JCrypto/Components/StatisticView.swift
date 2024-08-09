//
//  StatisticView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 04/08/24.
//

import SwiftUI

struct StatisticView: View {
  let staticData: Statistic
    var body: some View {
      VStack {
        Text(staticData.title)
          .font(.caption)
          .foregroundColor(Color.theme.SecondaryTextColor)
          Text(staticData.value)
            .font(.headline)
          .foregroundColor(Color.theme.AccentColor)
        HStack {
          Image(systemName: "triangle.fill")
            .font(.caption2)
            .rotationEffect(Angle(degrees: staticData.percentageChnage ?? 0 >=
                                  0 ? 0 : 180))
          Text(staticData.percentageChnage?.asPercentString() ?? "")
        }
        .foregroundColor(
          staticData.percentageChnage ?? 0 >= 0 ?
          Color.theme.GreenColor : Color.theme.RedColor
        )
        .opacity(staticData.percentageChnage == nil ? 0 : 1)
      }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
      StatisticView(staticData: dev.stat3)
    }
}
