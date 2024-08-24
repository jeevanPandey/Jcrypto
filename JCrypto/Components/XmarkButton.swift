//
//  XmarkButton.swift
//  JCrypto
//
//  Created by Jeevan Pandey on 18/08/24.
//

import SwiftUI

struct XmarkButton: View {
  @Environment(\.dismiss) var dismiss
  var body: some View {
    Button {
      debugPrint("dismiss me")
      dismiss()
    } label: {
      Image(systemName: "xmark")
    }
  }
}

struct XmarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XmarkButton()
  }
}
