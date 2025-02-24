//
//  HeaderView.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct InfoBannerView: View {
    let title: LocalizedStringKey
    let info: LocalizedStringKey
    @State private var showAlert = false

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: {
                showAlert = true
            }) {
                Image(systemName: "info.circle")
            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(title),
                message: Text(info)
            )
        }
    }
}

extension InfoBannerView {
    static let zendeskInitialization = InfoBannerView(title: "Zendesk Initialization", info: "Zendesk Initialization info")
    static let showMessaging: some View = InfoBannerView(title: ("Show Messaging"), info: "Show Messaging info").buttonStyle(PlainButtonStyle())
    static let authentication = InfoBannerView(title: "Zendesk Authentication", info: "Zendesk Authentication info")
    static let pageView = InfoBannerView(title: "Zendesk Page View Events", info: "Zendesk Page View Events info")
}
