//
//  CoinImageView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 16/10/22.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var coinImageVM: CoinImageViewModel
    init(imagePath:String) {
        let fileArray = imagePath.components(separatedBy: "images/")
       
        let finalFileName = fileArray.last
        let vm = CoinImageViewModel(imagePath: finalFileName ?? "")
        _coinImageVM = StateObject(wrappedValue: vm)
    }
    var body: some View {
        ZStack {
            if let image = coinImageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.theme.SecondaryTextColor)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(imagePath: dev.coin.image)
    }
}
