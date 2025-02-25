//
//  ContentView.swift
//  SwiftUIIntegration
//
//  Copyright © 2025 Zendesk. All rights reserved.
//

import SwiftUI
import ZendeskSDK
import ZendeskSDKMessaging
import OSLog

/// The main content view for the Zedesk SDK Demo App.
struct ContentView: View {

    @State private var channelKey: String
    @State private var jwt: String
    @State private var currentUser: ZendeskSDK.ZendeskUser?
    @State private var isInitialized: Bool = false {
        didSet {
            if isInitialized, !jwt.isEmpty { loginUser() }
        }
    }
    @State private var isLoggedIn: Bool = false {
        didSet {
            if !isLoggedIn { currentUser = nil }
        }
    }
    @State private var pageViewTitle: String = ""
    @State private var pageViewUrl: String = ""

    private let logger = Logger(subsystem: Constants.bundleIdentifier, category: Constants.category)

    /// Initialize the ContentView with the stored channel key and JWT token.
    init() {
        channelKey = UserDefaults.standard.string(forKey: Constants.channelKey) ?? ""
        jwt = UserDefaults.standard.string(forKey: Constants.jwtKey) ?? ""
    }

    var body: some View {
        NavigationView {
            List {
                // Initialization
                Section(header: InfoBannerView.zendeskInitialization) {
                    InitializationItem(channelKey: $channelKey, initialize: {
                        initializeZendeskSDK()
                    }, invalidate: { clearStorage in
                        invalidateZendeskSDK(clearStorage: clearStorage)
                    })
                    NavigationLink(destination: MessagingView()) {
                        InfoBannerView.showMessaging
                    }
                    .disabled(!isInitialized)
                    .opacity(isInitialized ? 1 : 0.5)
                }
                // Authentication
                Section(header: InfoBannerView.authentication) {
                    AuthenticationItem(jwt: $jwt, login: {
                        loginUser()
                    }, logout: {
                        logoutUser()
                    })
                    if let currentUser {
                        Text("User authenticated: \(currentUser.id)")
                    } else {
                        Text("No user authenticated")
                    }
                }
                .disabled(!isInitialized)
                .opacity(isInitialized ? 1 : 0.5)
                // Page View Events
                Section(header: InfoBannerView.pageView) {
                    ClearableTextField(placeholder: "Page view title", text: $pageViewTitle)
                    ClearableTextField(placeholder: "Page view URL", text: $pageViewUrl)
                    Button {
                        sendPageViewEvent()
                    } label: {
                        Text("Send Page View Event")
                    }
                    Text("This is a new text")
                }
                .disabled(!isInitialized)
                .opacity(isInitialized ? 1 : 0.5)
            }
            .navigationTitle("Zendesk SDK Demo App")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if !channelKey.isEmpty {
                initializeZendeskSDK()
            }
        }
    }

}

// MARK: - Zendesk SDK Functions
extension ContentView {
    /// Initialize Zendesk SDK with the provided channel key.
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/getting_started/#initialize-the-sdk
    func initializeZendeskSDK() {
        Task {
            do {
                // Initialize the Zendesk SDK with the provided channel key and a default messaging factory.
                // The messaging factory is used to create messaging instances.
                // It returns a Zendesk instance that can be used to interact with the SDK.
                // The Zendesk instance is a singleton and can be used throughout the app with `Zendesk.instance`.
                _ = try await Zendesk.initialize(withChannelKey: channelKey, messagingFactory: DefaultMessagingFactory())
                logger.notice("Zendesk Initialization success")
                logger.notice("Channel Key: \(channelKey)")
                UserDefaults.standard.set(channelKey, forKey: Constants.channelKey)
                isInitialized = true
            } catch let error {
                isInitialized = false
                logger.error("Zendesk Initialization error = \(error.localizedDescription)")
            }
        }
    }

    /// Invalidate Zendesk SDK instance and optionally clear storage.
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#invalidate-the-sdk
    /// - Parameter clearStorage: A boolean value to clear storage
    func invalidateZendeskSDK(clearStorage: Bool) {
        // Invalidate the Zendesk instance and optionally clear the storage (cache, database, etc.).
        Zendesk.invalidate(clearStorage)
        isInitialized = false
        logger.notice("Zendesk intance has been invalidated")
        if clearStorage {
            logger.notice("Zendesk storage has been cleared")
        }
    }

    /// Login user with the provided JWT token.
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#authentication
    func loginUser() {
        Task {
            do {
                currentUser = try await Zendesk.instance?.loginUser(with: jwt)
                logger.notice("Zendesk Authentication success")
                logger.notice("User id: \(String(describing: currentUser?.id))")
                UserDefaults.standard.set(jwt, forKey: Constants.jwtKey)
                isLoggedIn = true
            } catch let error {
                isLoggedIn = false
                logger.error("Zendesk Authentication error = \(error.localizedDescription)")
            }
        }
    }

    /// Logout user.
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#logoutuser
    func logoutUser() {
        Task {
            do {
                // Logout the user. This will clear the current user and all associated data.
                // Can be called for a logged user or for anonymous users.
                // In the case of an anonymous user, the next messaging presentation will create a new anonymous user.
                try await Zendesk.instance?.logoutUser()
                logger.notice("Zendesk Un-Authentication success")
                UserDefaults.standard.removeObject(forKey: "jwt")
                isLoggedIn = false
                currentUser = nil
            } catch let error {
                isLoggedIn = true
                logger.error("Zendesk Un-Authentication error = \(error.localizedDescription)")
            }
        }
    }

    /// Send a page view event to Zendesk.
    /// The Visitor Path lets agents see what screen the end user had landed on, for better conversation context.
    /// https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#visitor-path
    func sendPageViewEvent() {
        Task {
            do {
                // Create a page view event.
                let pageViewEvent = PageView(pageTitle: pageViewTitle, url: pageViewUrl)
                // Send the page view event to Zendesk.
                try await Zendesk.instance?.sendPageViewEvent(pageViewEvent)
                logger.notice("Zendesk Page View Event sent")
            } catch let error {
                logger.error("Zendesk Page View Event error = \(error.localizedDescription)")
            }
        }
    }
}

/// Preview provider for ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
