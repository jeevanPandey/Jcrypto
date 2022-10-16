//
//  CircleButtonView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName : String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.AccentColor)
            .frame(width: 50.0, height: 50.0)
            .background(){
                Circle()
                    .foregroundColor(Color.theme.BackgroundColor)
            }
            .shadow(color: Color.theme.AccentColor.opacity(0.3), radius: 10.0,
                    x: 0, y: 0)
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "info")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
