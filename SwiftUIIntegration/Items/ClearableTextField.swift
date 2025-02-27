//
//  ClearableTextField.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct ClearableTextField: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if !text.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .opacity(!text.isEmpty ? 1 : 0)
                    .onTapGesture { text = "" }
                    .animation(.easeInOut(duration: 0.2), value: text)
            }
        }
    }
}
