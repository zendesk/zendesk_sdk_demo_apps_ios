//
//  FormItem.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct FormItem: View {

    let title: LocalizedStringKey
    let placeHolder: LocalizedStringKey
    let validateTitle: LocalizedStringKey
    let invalidateTitle: LocalizedStringKey
    @Binding var value: String
    let validate: @MainActor () -> Void
    let invalidate: @MainActor () -> Void

    var body: some View {
        VStack {
            Text(title)
            ClearableTextField(placeholder: placeHolder, text: $value)
            HStack {
                Spacer()
                Button {
                    validate()
                } label: {
                    Text(validateTitle)
                        .foregroundColor(.blue)
                }
                Spacer()
                Button {
                    invalidate()
                } label: {
                    Text(invalidateTitle)
                        .foregroundColor(.red)
                }
                Spacer()
            }
        }.buttonStyle(PlainButtonStyle())
    }
}
