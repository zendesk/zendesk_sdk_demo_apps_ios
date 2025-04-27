//
//  MessagingView.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//
import UIKit
import SwiftUI
import ZendeskSDK
import ZendeskSDKLogger
import ZendeskSDKMessaging

/// A `View` that wraps the `MessagingViewController`.
struct MessagingView: View {

    let isModal: Bool

    init(isModal: Bool = false) {
#if DEBUG
        Logger.enabled = true
#endif
        self.isModal = isModal
    }

    var body: some View {
        ViewControllerWrapper(
            viewController: Zendesk.instance?.messaging?.messagingViewController(),
            isModal: isModal
        ).ignoresSafeArea()
    }
}

/// A `View` that wraps the `MessagingViewController` to present when a messaging notification is tapped.
struct MessagingNotificationView: View {
    var body: some View {
        ViewControllerWrapper(viewController: NotificationManager.shared.presentMessagingView)
            .ignoresSafeArea()
    }
}

/// A `UIViewControllerRepresentable` that wraps a `UIViewController`.
struct ViewControllerWrapper: UIViewControllerRepresentable {
    var viewController: UIViewController?
    let isModal: Bool

    init(viewController: UIViewController?, isModal: Bool = false) {
        self.viewController = viewController
        self.isModal = isModal
    }

    func makeUIViewController(context: Context) -> UIViewController {
        if isModal {
            UINavigationController(rootViewController: viewController ?? ErrorViewController())
        } else {
            viewController ?? ErrorViewController()
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}

/// A `UIViewController` that displays an error message.
class ErrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let errorLabel = UILabel()
        errorLabel.text = "Failed to initialize Zendesk"
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
