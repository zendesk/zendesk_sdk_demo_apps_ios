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
    var body: some View {
        MessagingViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

/// A `UIViewControllerRepresentable` that wraps the `MessagingViewController`.
fileprivate struct MessagingViewControllerRepresentable: UIViewControllerRepresentable {

    init() {
        #if DEBUG
        Logger.enabled = true
        #endif
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> UIViewController {
        Zendesk.instance?.messaging?.messagingViewController() ?? ErrorViewController()
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
