//
//  CircleanimationView.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 11/10/22.
//

import SwiftUI

struct CircleanimationView: View {
    @Binding var shouldAnimate : Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 3.0)

            .scale(shouldAnimate ? 1.0 : 0.0)
            .opacity(shouldAnimate ? 1.0 : 0.0)
            
            .animation(shouldAnimate ? Animation.easeInOut(duration: 1.0) : nil , value: UUID())
            .onAppear {
                shouldAnimate.toggle()
            }
    }
}

struct CircleanimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleanimationView(shouldAnimate: .constant(true))
            .frame(width: 100.0, height: 100.0)
    }
}
