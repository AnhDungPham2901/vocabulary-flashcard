//
//  CustomTextField.swift
//  frontend-ios
//
//  Created by PHAM ANH DUNG on 26/8/25.
//

import SwiftUI

// The purpose of this component is to make the default TextField provided by Apple look better.
// And we can reuse this custom TextField across our app to make sure it looks consistently
struct CustomTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(.tertiarySystemBackground))
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color.blue.opacity(0.3), lineWidth: 1)
          )
      )
      .font(.body)
  }
}
