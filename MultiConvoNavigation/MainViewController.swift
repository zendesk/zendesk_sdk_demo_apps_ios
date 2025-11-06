//
//  MainViewController.swift
//  MultiConvoNavigation
//
//  Created by Cris Burlamaqui on 29/10/2025.
//

import UIKit
import ZendeskSDK
import ZendeskSDKMessaging

class MainViewController: UIViewController {
    
    @IBOutlet weak var navBarInfo: UIBarButtonItem!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    static let initializeCardCell = "InitializeCardCell"
    static let showConversationCardCell = "ShowConversationCardCell"
    static let footerHeight: CGFloat = 20
    static let numberOfSections: Int = 6
    static let numberOfRows: Int = 1
    var gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "InitializeSDKCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.initializeCardCell)
        tableView.register(UINib(nibName: "ShowConversationCardCell", bundle: nil), forCellReuseIdentifier: MainViewController.showConversationCardCell)
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

    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
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
        MainViewController.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MainViewController.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = [indexPath.row, indexPath.section]
        
        if index == [0,0] {
            return initCell(indexPath: indexPath)
        } else if index == [0,1] {
            return presentDefaultCell(indexPath: indexPath)
        } else if index == [0,2] {
            return presentConversationListCell(indexPath: indexPath)
        } else if index == [0,3] {
            return presentConversationWithIDCell(indexPath: indexPath)
        } else if index == [0,4] {
            return presentMostRecentConversationCell(indexPath: indexPath)
        } else if index == [0,5] {
            return presentNewConversationCell(indexPath: indexPath)
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        MainViewController.footerHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

extension MainViewController {

    func initCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.initializeCardCell, for: indexPath
        ) as? InitializeSDKCardCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
#warning("Provide channel key")
        let channel_key = ""

        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
#warning("Basic init code with a custom alert in case of failure, and a custom toast in case of success.")
            Zendesk.initialize(withChannelKey: channel_key,
                               messagingFactory: DefaultMessagingFactory()) { result in
                if case let .failure(error) = result {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.showToast(message: "Initialization Successful", seconds: 2)
                    }
                }
            }
        }
        return cell
    }

    func presentDefaultCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.showConversationCardCell, for: indexPath
        ) as? ShowConversationCardCell else {
            // If table view fails to dequeue the cell we want (InitializeSDKCardCell) then show a dumb table view cell
            return UITableViewCell()
        }
        cell.cardTitle.text = "Show Conversation (Default option)"
        cell.cardDescription.text = "Displays the most recent conversation screen as default option. A user and a new conversation will automatically be created if they don't exist. Ensure you have previously initialized the Zendesk SDK."
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
#warning("Basic conversation presentation via the navigation controller.")
            // In case none of the options of MessagingScreen is provided the default one is Show Most Recent Conversation.
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

    func presentConversationListCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.showConversationCardCell, for: indexPath
        ) as? ShowConversationCardCell else {
            return UITableViewCell()
        }
        cell.cardTitle.text = "Show Conversation List"
        cell.cardDescription.text = "Displays the list of all conversations screen. A user and a new conversation will automatically be created if they don't exist. Ensure you have previously initialized the Zendesk SDK."
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController(.showConversationList) else { return }
            self.navigationController?.show(viewController, sender: self)
        }
        return cell
    }

    func presentConversationWithIDCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.showConversationCardCell, for: indexPath
        ) as? ShowConversationCardCell else {
            return UITableViewCell()
        }
        cell.cardTitle.text = "Show Conversation With ID"
        cell.cardDescription.text = "Displays a specific conversation privided by an ID. A user and a new conversation will automatically be created if they don't exist. Ensure you have previously initialized the Zendesk SDK."
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
#warning("Provide a conversation ID")
            let conversation_ID = ""
            // The exit action can be .returnToConversationList in case the application should return to the conversation list
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController(.showConversation(conversationId: conversation_ID, exitAction: .close)) else { return }
            self.navigationController?.show(viewController, sender: self)
        }
        return cell
    }

    func presentMostRecentConversationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.showConversationCardCell, for: indexPath
        ) as? ShowConversationCardCell else {
            return UITableViewCell()
        }
        cell.cardTitle.text = "Show Most Recent Conversation"
        cell.cardDescription.text = "Displays the  most recent conversation screen. A user and a new conversation will automatically be created if they don't exist. Ensure you have previously initialized the Zendesk SDK."
        cell.clickHandler = {[weak self] in
            guard let self = self else { return }
            // The exit action can be .close in case the application should exit the SDK
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController(.showMostRecentConversation(exitAction: .returnToConversationList)) else { return }
            self.navigationController?.show(viewController, sender: self)
        }
        return cell
    }

    func presentNewConversationCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewController.showConversationCardCell, for: indexPath
        ) as? ShowConversationCardCell else {
            return UITableViewCell()
        }
        cell.cardTitle.text = "Show New Conversation"
        cell.cardDescription.text = "Displays a new conversation screen. A user will automatically be created if it doesn't exist and a new conversation will be created each time this option is chosen. Ensure you have previously initialized the Zendesk SDK."
        cell.clickHandler = {[weak self] in
            guard let self else { return }
            // The exit action can be .returnToConversationList in case the application should return to the conversation list
            guard let viewController = Zendesk.instance?.messaging?.messagingViewController(.showNewConversation(exitAction: .close)) else { return }
            self.navigationController?.show(viewController, sender: self)
        }
        return cell
    }
}

