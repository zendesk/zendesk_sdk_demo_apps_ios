//
//  InitializeSDKCardCell.swift
//  hello_world
//
//  Created by Andrew Dietrich on 3/7/23.
//

import UIKit


class InitializeSDKCardCell: UITableViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var callToActionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var clickHandler: (() -> Void)?

    @IBOutlet weak var stackView: UIStackView!


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

        cardDescription.text = "Initializes the Zendesk SDK with the channel key specified in the demo source code. Initializing will load your settings, and prepare the SDK to show a conversation."

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
