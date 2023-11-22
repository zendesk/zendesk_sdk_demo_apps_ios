//
//  InitializeSDKCardCell.swift
//  hello_world
//
//  Created by Andrew Dietrich on 3/7/23.
//

import UIKit
import ZendeskSDK

class AuthenticationCell: UITableViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var loginHandler: (() -> Void)?
    var logoutHandler: (() -> Void)?

    @IBOutlet weak var stackView: UIStackView!


    override func awakeFromNib() {
        super.awakeFromNib()
        styling()
    }



    @IBAction func loginButtionClicked(_ sender: Any) {
        loginHandler?()

    }

    @IBAction func logOutButtonClicked(_ sender: Any) {
        logoutHandler?()
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

        cardDescription.text = "The Zendesk SDK allows authentication of end users so their identity can be trusted by agents using Zendesk."

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

        self.logInButton.backgroundColor = UIColor(named: "cardButtonColor")
        self.logInButton.titleLabel?.tintColor = UIColor(named: "cardButtonLabelColor")
        self.logInButton.layer.cornerRadius = 14

        self.logOutButton.backgroundColor = UIColor(named: "logOutButtonColor")
        self.logOutButton.titleLabel?.tintColor = UIColor(named: "cardButtonColor")
        self.logOutButton.layer.cornerRadius = 14

        self.backgroundView = backgroundView

    }

}
