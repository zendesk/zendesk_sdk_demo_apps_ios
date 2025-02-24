//
//  AuthenticationItem.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct AuthenticationItem: View {

    @Binding var jwt: String
    let login: @MainActor () -> Void
    let logout: @MainActor () -> Void

    var body: some View {
        FormItem(
            title: "Authentication",
            placeHolder: "Enter JWT",
            validateTitle: "Login",
            invalidateTitle: "Logout",
            value: $jwt,
            validate: login,
            invalidate: logout
        )
    }
}
