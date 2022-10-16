//
//  JCryptoApp.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 10/10/22.
//

import SwiftUI

@main
struct JCryptoApp: App {
    @StateObject var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
        }
    }
}
