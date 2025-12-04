//
//  MainViewController.swift
//
//  Copyright © 2023 Zendesk. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskSDKMessaging

class MainViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var navBarInfo: UIBarButtonItem!
    @IBOutlet var demoAppView: UIView!
    @IBOutlet weak var tableView: UITableView!
    static let initializeCardCell = "InitializeCardCell"
    static let showConversationCardCell = "ShowConversationCardCell"
    static let authenticationCell = "AuthenticationCell"
    var gradientLayer = CAGradientLayer()

    // MARK: - Bug Reproduction Mode
    // Set to true to automatically reproduce the input field disappearing bug
    private let enableBugReproductionMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        styling()
        tableView.register(UINib(nibName: "InitializeSDKCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.initializeCardCell)
        tableView.register(UINib(nibName: "AuthenticationCell", bundle: nil), forCellReuseIdentifier: MainViewController.authenticationCell)
        tableView.register(UINib(nibName: "ShowConversationCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.showConversationCardCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear

        // Auto-initialize and authenticate to reproduce the bug
        if enableBugReproductionMode {
            print("[BUG REPRODUCTION] Mode enabled - will auto-authenticate and show conversation")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.autoInitializeAndAuthenticate()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle == .dark {
            
            gradientLayer.removeFromSuperlayer()
            backgroundView.backgroundColor = UIColor(named: "backgroundColor")
            
        }
        
        if traitCollection.userInterfaceStyle == .light {
            insertGradientLayer(gradientLayer, backgroundView: backgroundView)
        }
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        makeAlert(title: "About this app", message: "This demo app is to help developers get up and running with the Zendesk SDK by providing a quick working example of the software, and providing some useful quick action buttons explore the end user experience.")
    }
    
    func styling() {
        let infoButtonColor = UIColor(named: "navTitleColor")
        navBarInfo.tintColor = infoButtonColor
        
        if traitCollection.userInterfaceStyle == .light {
            insertGradientLayer(gradientLayer, backgroundView: backgroundView)
        } else {
            backgroundView.backgroundColor = UIColor(named: "backgroundColor")
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = [indexPath.row, indexPath.section]
        
        if index == [0,0] {
            return initCell(indexPath: indexPath)
        }
        if index == [0,1] {
            return authenticationCell(indexPath: indexPath)
        }
        if index == [0,2] {
            return presentCell(indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.isOpaque = false
        view.frame.size.height = 16
        
        return view
    }
    
}

extension MainViewController {
    func initCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.initializeCardCell, for: indexPath) as? InitializeSDKCardCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
#warning("provide channel key")
        let channel_key = "YOUR_CHANNEL_KEY_HERE"

        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
            
#warning("Basic init code with a custom alert in case of failure, and a custom toast in case of success.")
            Zendesk.initialize(withChannelKey: channel_key,
                               messagingFactory: DefaultMessagingFactory()) { result in
                if case let .failure(error) = result {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    Zendesk.instance?.messaging?.enableInternalAnalytics(enabled: false)
                    DispatchQueue.main.async {
                        self.showToast(message: "Initialization Successful", seconds: 2)
                    }
                }
            }
        }
        return cell
    }
    
    func presentCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.showConversationCardCell, for: indexPath) as? ShowConversationCardCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
            
#warning("Basic conversation presentation via the navigation controller.")
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController() else { return }
            self.navigationController?.show(viewController, sender: self)

            // This is an alternative way to present the messaging view controller using modal presention.
            // When presenting modally, the messaging view controller needs to be in a navigation controller to work properly.
//            self.navigationController?.present(
//                UINavigationController(rootViewController: viewController),
//                animated: true,
//                completion: nil
//            )
        }
        return cell
    }
    
    func authenticationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.authenticationCell, for: indexPath) as? AuthenticationCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
        
#warning("Basic JWT auth, with a custom alert in case of failure, and a custom toast in case of success.")
        cell.loginHandler = { [weak self] in
            guard let self = self else { return }
#warning ("Provide JWT token from your service")
            let jwt_token = "YOUR_JWT_TOKEN_HERE"
            
            Zendesk.instance?.loginUser(with: jwt_token) { result in
                if case let .failure(error) = result {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message: "Authentication Successful", seconds: 2)
                    }
                }
            }
            
        }
        
        cell.logoutHandler = { [weak self] in
            guard let self = self else { return }
            
            
            Zendesk.instance?.logoutUser { result in
                if case let .failure(error) = result {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message: "Logout Successful", seconds: 2)
                    }
                }
            }
            
        }
        


        return cell
    }

    // MARK: - Bug Reproduction Methods

    /// Auto-initializes SDK and authenticates user to reproduce the bug
    /// This simulates the customer's flow where they authenticate and immediately open conversation
    private func autoInitializeAndAuthenticate() {
        print("[BUG REPRODUCTION] Step 1: Initializing SDK...")

#warning("provide channel key")
        let channel_key = "YOUR_CHANNEL_KEY_HERE"

        Zendesk.initialize(withChannelKey: channel_key,
                           messagingFactory: DefaultMessagingFactory()) { [weak self] result in
            if case let .failure(error) = result {
                print("[BUG REPRODUCTION] SDK initialization failed: \(error.localizedDescription)")
                self?.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                print("[BUG REPRODUCTION] SDK initialized successfully")
                Zendesk.instance?.messaging?.enableInternalAnalytics(enabled: false)

                DispatchQueue.main.async {
                    self?.showToast(message: "SDK Initialized - Authenticating...", seconds: 1.5)
                }

                // Immediately authenticate after initialization
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.autoAuthenticateUser()
                }
            }
        }
    }

    /// Authenticates user with JWT token
    private func autoAuthenticateUser() {
        print("[BUG REPRODUCTION] Step 2: Authenticating user...")

#warning ("Provide JWT token from your service")
        let jwt_token = "YOUR_JWT_TOKEN_HERE"

        Zendesk.instance?.loginUser(with: jwt_token) { [weak self] result in
            if case let .failure(error) = result {
                print("[BUG REPRODUCTION] Authentication failed: \(error.localizedDescription)")
                self?.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                print("[BUG REPRODUCTION] User authenticated successfully")

                DispatchQueue.main.async {
                    self?.showToast(message: "Authenticated - Opening Conversation...", seconds: 1.5)
                }

                // CRITICAL: Immediately show conversation after authentication
                // This triggers rapid conversation updates that cause the bug
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.autoShowConversation()
                }
            }
        }
    }

    /// Shows conversation immediately after authentication
    /// This reproduces the customer's flow and triggers the bug
    private func autoShowConversation() {
        print("[BUG REPRODUCTION] Step 3: Opening conversation immediately...")
        print("[BUG REPRODUCTION] Watch for rapid 'Conversation updated' events")
        print("[BUG REPRODUCTION] If input field is missing, the bug is reproduced!")

        guard let viewController = Zendesk.instance?.messaging?.messagingViewController() else {
            print("[BUG REPRODUCTION] Failed to get messaging view controller")
            return
        }

        print("[BUG REPRODUCTION] Presenting conversation view controller")
        self.navigationController?.show(viewController, sender: self)

        // Give user feedback about what to check
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("[BUG REPRODUCTION] CHECK NOW:")
            print("   - Is the input field visible at the bottom?")
            print("   - Can you tap and type in the input field?")
            print("   - If NOT visible = BUG REPRODUCED!")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        }
    }

}
