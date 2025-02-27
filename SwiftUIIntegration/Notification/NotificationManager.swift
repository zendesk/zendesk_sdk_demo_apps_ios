//
//  AppDelegate.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//

import UserNotifications
import ZendeskSDKMessaging
import SwiftUI

class NotificationManager: ObservableObject {

    public static let shared = NotificationManager()
    @Published private(set) var presentMessagingView: UIViewController?

    public func handle(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        PushNotifications.handleTap(userInfo) { [weak self] viewController in
            if let self, let viewController = viewController {
                presentMessagingView = nil
                presentMessagingView = viewController
            }
        }
    }

    public func reset() {
        presentMessagingView = nil
    }
}
