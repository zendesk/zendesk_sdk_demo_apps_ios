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
        3  // Initialize (optional), Authentication (Login/Logout), Show Conversation
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
        let channel_key = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3o0bm5tdGVzdGFwcC56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUpIUUVIWERCUDg2V0RGN0ZHQ0UwUzBKTi5qc29uIn0="

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
            return UITableViewCell()
        }
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }

            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("✅ [FIRST TIME] Show Conversation → Init + Login + Show")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            // Check if already initialized
            if Zendesk.instance != nil {
                print("✅ [FIRST TIME] SDK already initialized")
                self.showConversationWithLogin()
            } else {
                print("🔄 [FIRST TIME] Initializing SDK...")
                let channel_key = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3o0bm5tdGVzdGFwcC56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUpIUUVIWERCUDg2V0RGN0ZHQ0UwUzBKTi5qc29uIn0="

                Zendesk.initialize(withChannelKey: channel_key, messagingFactory: DefaultMessagingFactory()) { [weak self] result in
                    if case let .failure(error) = result {
                        print("❌ [FIRST TIME] Init failed")
                        self?.makeAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        print("✅ [FIRST TIME] SDK initialized")
                        Zendesk.instance?.messaging?.enableInternalAnalytics(enabled: false)
                        self?.showConversationWithLogin()
                    }
                }
            }
        }
        return cell
    }

    func showConversationWithLogin() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF82ODJiMWI1YTI2MjM4MWM2YTBkNDZmZjcifQ.eyJzY29wZSI6InVzZXIiLCJuYW1lIjoiRGVuaXMiLCJlbWFpbCI6ImRlbmkxMTFzQG1haWwuZGUiLCJleHRlcm5hbF9pZCI6IjEyMzQ1ZGZkZjY3OCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpYXQiOjE3NjU5NjY4NjEsImV4cCI6MTc2NjAyNjg2MX0.iSy8xE5dG-GQBtCnomdCxAjGI50BG2v5J7ApBImfCwc"

        Zendesk.instance?.loginUser(with: jwt) { [weak self] result in
            if case let .failure(error) = result {
                print("❌ [FIRST TIME] Login failed")
                self?.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                print("✅ [FIRST TIME] Login successful")
                print("✅ [FIRST TIME] Showing conversation (with delay)")
                print("✅ [FIRST TIME] This should WORK normally\n")

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let vc = Zendesk.instance?.messaging?.messagingViewController() else { return }
                    self?.navigationController?.show(vc, sender: self)
                }
            }
        }
    }
    
    func authenticationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.authenticationCell, for: indexPath) as? AuthenticationCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
        
#warning("Basic JWT auth, with a custom alert in case of failure, and a custom toast in case of success.")
        cell.loginHandler = { [weak self] in
            guard let self = self else { return }

            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("🔴 [BUG REPRO] Login button → Login + IMMEDIATE show")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

#warning ("Provide JWT token from your service")
            let jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF82ODJiMWI1YTI2MjM4MWM2YTBkNDZmZjcifQ.eyJzY29wZSI6InVzZXIiLCJuYW1lIjoiRGVuaXMiLCJlbWFpbCI6ImRlbmkxMTFzQG1haWwuZGUiLCJleHRlcm5hbF9pZCI6IjEyMzQ1ZGZkZjY3OCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpYXQiOjE3NjU5NjY4NjEsImV4cCI6MTc2NjAyNjg2MX0.iSy8xE5dG-GQBtCnomdCxAjGI50BG2v5J7ApBImfCwc"

            Zendesk.instance?.loginUser(with: jwt_token) { [weak self] result in
                if case let .failure(error) = result {
                    print("❌ [BUG REPRO] Login failed")
                    self?.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    print("✅ [BUG REPRO] Login success")
                    print("💥 [BUG REPRO] IMMEDIATE show conversation (< 10ms)")
                    print("💥 [BUG REPRO] Should trigger INFINITE SPINNER!")

                    DispatchQueue.main.async {
                        self?.showToast(message: "Logged in - showing...", seconds: 1.5)
                    }

                    // IMMEDIATE show - no delay!
                    DispatchQueue.main.async {
                        guard let vc = Zendesk.instance?.messaging?.messagingViewController() else { return }
                        self?.navigationController?.show(vc, sender: self)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                            print("🔍 [CHECK] Do you see spinner? = BUG!")
                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
                        }
                    }
                }
            }

        }
        
        cell.logoutHandler = { [weak self] in
            guard let self = self else { return }

            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print("🔄 [LOGOUT] Logging out...")
            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            Zendesk.instance?.logoutUser { result in
                if case let .failure(error) = result {
                    print("❌ [LOGOUT] Failed")
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    print("✅ [LOGOUT] Success - storage cleared")
                    print("💡 [NEXT] Tap Login to reproduce bug\n")
                    DispatchQueue.main.async {
                        self.showToast(message: "Logged out - tap Login for bug", seconds: 2)
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
        let channel_key = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3o0bm5tdGVzdGFwcC56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUpIUUVIWERCUDg2V0RGN0ZHQ0UwUzBKTi5qc29uIn0="

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

    // MARK: - Logout/Relogin Spinner Bug Reproduction (Vestiaire Collective)

    /// Creates a cell with buttons to test logout/relogin spinner bug
    func logoutReloginBugCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "LogoutReloginBugCell")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4
        cell.contentView.addSubview(containerView)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "🐛 Logout/Relogin Spinner Bug"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.text = "Vestiaire Collective Issue"
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.textAlignment = .center
        containerView.addSubview(descLabel)

        // Green button: Normal flow
        let normalButton = UIButton(type: .system)
        normalButton.translatesAutoresizingMaskIntoConstraints = false
        normalButton.setTitle("✅ Login & Show", for: .normal)
        normalButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        normalButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        normalButton.setTitleColor(.systemGreen, for: .normal)
        normalButton.layer.cornerRadius = 8
        normalButton.layer.borderWidth = 1
        normalButton.layer.borderColor = UIColor.systemGreen.cgColor
        normalButton.addTarget(self, action: #selector(testNormalLoginFlow), for: .touchUpInside)
        containerView.addSubview(normalButton)

        // Red button: Bug reproduction
        let bugButton = UIButton(type: .system)
        bugButton.translatesAutoresizingMaskIntoConstraints = false
        bugButton.setTitle("🔴 Logout→Login→Show", for: .normal)
        bugButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bugButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        bugButton.setTitleColor(.systemRed, for: .normal)
        bugButton.layer.cornerRadius = 8
        bugButton.layer.borderWidth = 1
        bugButton.layer.borderColor = UIColor.systemRed.cgColor
        bugButton.addTarget(self, action: #selector(testLogoutReloginBug), for: .touchUpInside)
        containerView.addSubview(bugButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            normalButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            normalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            normalButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            normalButton.heightAnchor.constraint(equalToConstant: 50),
            bugButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: 12),
            bugButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bugButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bugButton.heightAnchor.constraint(equalToConstant: 50),
            bugButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        return cell
    }

    /// Normal flow: Login and show conversation (should work)
    @objc func testNormalLoginFlow() {
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("✅ [NORMAL] Testing normal flow...")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

#warning("⚠️ Replace with your JWT token")
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF82ODJiMWI1YTI2MjM4MWM2YTBkNDZmZjcifQ.eyJzY29wZSI6InVzZXIiLCJuYW1lIjoiRGVuaXMiLCJlbWFpbCI6ImRlbmkxMTFzQG1haWwuZGUiLCJleHRlcm5hbF9pZCI6IjEyMzQ1ZGZkZjY3OCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpYXQiOjE3NjU5NjY4NjEsImV4cCI6MTc2NjAyNjg2MX0.iSy8xE5dG-GQBtCnomdCxAjGI50BG2v5J7ApBImfCwc"

        Zendesk.instance?.loginUser(with: jwt) { [weak self] result in
            switch result {
            case .success(let user):
                print("✅ [NORMAL] Logged in: \(user.id)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let vc = Zendesk.instance?.messaging?.messagingViewController() else { return }
                    self?.navigationController?.show(vc, sender: self)
                    print("✅ [NORMAL] Should show conversation normally\n")
                }
            case .failure(let error):
                print("❌ [NORMAL] Login failed: \(error)")
            }
        }
    }

    /// Bug reproduction: Rapid logout→login→show (should show spinner)
    @objc func testLogoutReloginBug() {
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🔴 [BUG] Testing rapid logout→login→show...")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        print("🔴 [BUG] Step 1: LOGOUT")
        Zendesk.instance?.logoutUser { [weak self] _ in
            print("🔴 [BUG] ✅ Logged out")
            print("🔴 [BUG] Step 2: IMMEDIATE RE-LOGIN (< 10ms)")

#warning("⚠️ Replace with your JWT token (same as above)")
            let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF82ODJiMWI1YTI2MjM4MWM2YTBkNDZmZjcifQ.eyJzY29wZSI6InVzZXIiLCJuYW1lIjoiRGVuaXMiLCJlbWFpbCI6ImRlbmkxMTFzQG1haWwuZGUiLCJleHRlcm5hbF9pZCI6IjEyMzQ1ZGZkZjY3OCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpYXQiOjE3NjU5NjY4NjEsImV4cCI6MTc2NjAyNjg2MX0.iSy8xE5dG-GQBtCnomdCxAjGI50BG2v5J7ApBImfCwc"

            Zendesk.instance?.loginUser(with: jwt) { [weak self] result in
                switch result {
                case .success(let user):
                    print("🔴 [BUG] ✅ Re-logged in: \(user.id)")
                    print("🔴 [BUG] Step 3: IMMEDIATE SHOW (< 10ms)")
                    print("🔴 [BUG] 💥 Watch for infinite spinner!")

                    DispatchQueue.main.async {
                        guard let vc = Zendesk.instance?.messaging?.messagingViewController() else { return }
                        self?.navigationController?.show(vc, sender: self)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                            print("🔴 [BUG] CHECK NOW:")
                            print("   ❓ See messages? = Bug NOT reproduced")
                            print("   ❌ See spinner?  = BUG REPRODUCED!")
                            print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
                        }
                    }
                case .failure(let error):
                    print("❌ [BUG] Re-login failed: \(error)")
                }
            }
        }
    }

}
