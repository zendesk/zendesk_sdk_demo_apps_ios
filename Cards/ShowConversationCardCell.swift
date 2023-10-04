//
//  ShowConversationCardCell.swift
//  hello_world
//
//  Created by Andrew Dietrich on 3/12/23.
//

import UIKit
import ZendeskSDK
import ZendeskSDKMessaging

class ShowConversationCardCell: UITableViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var clickHandler: (() -> Void)?


    override func awakeFromNib() {
        super.awakeFromNib()
        styling()
    }

    @IBAction func callToAction(_ sender: Any) {

        clickHandler?()

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            self.contentView.layer.backgroundColor = UIColor.white.cgColor
        } else {
            self.contentView.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
            self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
        }
    }

    func styling() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        cardDescription.text = "Displays the conversation screen for the initial conversation created for your user. A user and a new conversation will automatically be created if they don't exist. Ensure you have previously initialized the Zendesk SDK."

        self.layer.cornerRadius = 14

        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 14
        self.contentView.layer.masksToBounds = true

        let backgroundView = UIView.init(frame: contentView.frame)
        backgroundView.backgroundColor = UIColor.clear
        
        if traitCollection.userInterfaceStyle == .light {
            self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
            self.contentView.layer.backgroundColor = UIColor.white.cgColor
        } else {
            self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
            self.contentView.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
        }

        self.callToActionButton.backgroundColor = UIColor(named: "cardButtonColor")
        self.callToActionButton.titleLabel?.tintColor = UIColor(named: "cardButtonLabelColor")
        self.callToActionButton.layer.cornerRadius = 14

        self.backgroundView = backgroundView
    }
}
