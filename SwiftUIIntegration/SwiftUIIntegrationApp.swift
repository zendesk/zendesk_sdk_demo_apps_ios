//
//  SwiftUIIntegrationApp.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//

import SwiftUI

@main
struct SwiftUIIntegrationApp: App {

    private let notificationDelegate = NotificationDelegate()

    init(){
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
