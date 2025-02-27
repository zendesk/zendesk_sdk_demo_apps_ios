//
//  NotificationViewModifier.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import SwiftUI

struct NotificationViewModifier: ViewModifier {
    // MARK: - Private Properties
    private let onNotification: (UIViewController) -> Void

    // MARK: - Initializers
    init(onNotification: @escaping (UIViewController) -> Void) {
        self.onNotification = onNotification
    }

    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationManager.shared.$presentMessagingView) { notification in
                guard let notification else { return }
                onNotification(notification)
            }
    }
}

extension View {
    func onNotification(perform action: @escaping (UIViewController) -> Void) -> some View {
        modifier(NotificationViewModifier(onNotification: action))
    }
}
