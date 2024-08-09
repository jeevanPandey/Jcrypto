//
//  SearchBarView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 17/04/24.
//

import SwiftUI

struct SearchBarView: View {
  @Binding var searchText: String
    var body: some View {
      HStack {
        Image(systemName: "magnifyingglass")
        TextField("Input your search...", text: $searchText)
          .disableAutocorrection(true)
          .foregroundColor(Color.blue.opacity(0.5))
          .overlay(alignment: .trailing, content: {
            Image(systemName: "multiply.circle")
              .padding()
              .offset(x: 10)
              .opacity(searchText.isEmpty ? 0.0 : 1.0)
              .onTapGesture {
                searchText = ""
                UIApplication.shared.endEditing()
              }
          })
        
      }
      .font(.headline)
      .padding()
      .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.theme.BackgroundColor)
            .shadow(color: Color.theme.AccentColor, radius: 0.5)
      )
      .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
      SearchBarView(searchText: .constant(""))
    }
}
