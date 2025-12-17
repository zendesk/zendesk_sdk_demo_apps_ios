//
//  MainViewController.swift
//
//  Copyright © 2023 Zendesk. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskSDKMessaging
import ZendeskSDKLogger

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var navBarInfo: UIBarButtonItem!
    @IBOutlet var demoAppView: UIView!
    @IBOutlet weak var tableView: UITableView!
    static let initializeCardCell = "InitializeCardCell"
    static let showConversationCardCell = "ShowConversationCardCell"
    static let authenticationCell = "AuthenticationCell"
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styling()
        tableView.register(UINib(nibName: "InitializeSDKCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.initializeCardCell)
        tableView.register(UINib(nibName: "ShowConversationCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.showConversationCardCell)
        tableView.register(UINib(nibName: "AuthenticationCell", bundle: nil), forCellReuseIdentifier: MainViewController.authenticationCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
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
        let channel_key = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3ozbmFiLTVkNjA3Yi1lMjlkY2Q3NzEzZmZiZDNiMDNlOGY4YzRlMGYyM2EwZTcyODcyNi56ZW5kZXNrLmNvbS9tb2JpbGVfc2RrX2FwaS9zZXR0aW5ncy8wMUs5NzhTWlAxSFg5RUVEQVhOQzY3VjhUVi5qc29uIn0="

        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
#warning("Basic init code with a custom alert in case of failure, and a custom toast in case of success.")
            Zendesk.initialize(withChannelKey: channel_key,
                               messagingFactory: DefaultMessagingFactory()) { result in
                if case let .failure(error) = result {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    // Enable SDK logging
                    Logger.enabled = true
                    Logger.level = .debug

                    DispatchQueue.main.async {
                        self.showToast(message: "Initialization Successful", seconds: 2)
                    }
                }
            }
        }
        return cell
    }

    func authenticationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewController.authenticationCell, for: indexPath) as? AuthenticationCell else {
            return UITableViewCell()
        }

#warning("JWT auth with login and logout buttons - JWT token can be edited in the text field")
        cell.loginHandler = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }

            let jwt_token: String
            if let textFieldToken = cell.jwtTextField?.text, !textFieldToken.isEmpty {
                jwt_token = textFieldToken
            } else {
                jwt_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF82OTA5ZGViMWE2N2VhODIwYzE5ZDJlZGIifQ.eyJzY29wZSI6InVzZXIiLCJuYW1lIjoiSmVzczgxOSIsImVtYWlsIjoiamVzcy5wKzgxOUBnbWFpbC5jb20iLCJleHRlcm5hbF9pZCI6IjMzODE5IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJpYXQiOjE3NjU5NDE4OTQsImV4cCI6MTc2Njk0MTg5M30.7UPuD-IErHdCVnItwDuf8JAEV7c3wl7Iecme8bon-R8"
                print("JEP: WARNING - Using fallback JWT token (text field not connected)")
            }

            print("JEP: Attempting login with JWT from text field...")
            print("JEP: JWT token: \(jwt_token.prefix(50))...")

            Zendesk.instance?.loginUser(with: jwt_token) { result in
                if case let .failure(error) = result {
                    print("JEP: Login failed: \(error.localizedDescription)")
                    self.makeAlert(title: "Login Error", message: error.localizedDescription)
                } else {
                    print("JEP: Login successful")
                    DispatchQueue.main.async {
                        self.showToast(message: "Login Successful", seconds: 2)
                    }
                }
            }
        }

        cell.logoutHandler = { [weak self] in
            guard let self = self else { return }

            print("JEP: Attempting logout...")
            Zendesk.instance?.logoutUser { result in
                if case let .failure(error) = result {
                    print("JEP: Logout failed: \(error.localizedDescription)")
                    self.makeAlert(title: "Logout Error", message: error.localizedDescription)
                } else {
                    print("JEP: Logout successful")
                    DispatchQueue.main.async {
                        self.showToast(message: "Logout Successful", seconds: 2)
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
#warning("Simple conversation presentation - open most recent conversation directly")
            print("JEP: Opening conversation screen...")
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController(.showMostRecentConversation(exitAction: .close)) else {
                print("JEP: Failed to get messaging view controller")
                self.makeAlert(title: "Error", message: "Could not get messaging view controller. Is SDK initialized?")
                return
            }

            print("JEP: Got messaging view controller, presenting...")
            self.navigationController?.pushViewController(viewController, animated: true)
            print("JEP: Conversation screen opened")
        }
        return cell
    }
}
