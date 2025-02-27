//
//  NotificationDelegate.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        NotificationManager.shared.handle(response: response)
    }
}
