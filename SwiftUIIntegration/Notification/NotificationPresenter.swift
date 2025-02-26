//
//  NotificationPresenter.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

/// A view that presents the messaging view to present when a message notification is tapped.
struct NotificationPresenter: View {
    @State private var isPresented = false
    var body: some View {
        NavigationLink(destination: MessagingNotificationView(), isActive: $isPresented) {
            EmptyView()
        }.onNotification { _ in
            isPresented = true
        }.onAppear {
            NotificationManager.shared.reset()
        }
    }
}
