//
//  InitializationItem.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct InitializationItem: View {

    @Binding var channelKey: String
    let initialize: @MainActor () -> Void
    let invalidate: @MainActor (Bool) -> Void
    @State private var showAlert = false

    var body: some View {
        FormItem(
            title: "Channel Key",
            placeHolder: "Enter Channel Key",
            validateTitle: "Initialize",
            invalidateTitle: "Invalidate",
            value: $channelKey,
            validate: initialize,
            invalidate: {
                showAlert = true
            }
        ).alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear Zendesk SDK Storage"),
                message: Text("Do you want to clear the existing Zendesk SDK storage?"),
                primaryButton: .default(Text("Yes")) {
                    invalidate(true)
                },
                secondaryButton: .cancel(Text("No")) {
                    invalidate(false)
                }
            )
        }
    }
}
