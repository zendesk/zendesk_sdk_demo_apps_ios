//
//  ShowUnreadCountCell.swift
//
//  Copyright © 2023 Zendesk. All rights reserved.
//

import UIKit


class ShowUnreadCountCell: UITableViewCell {

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

        cardDescription.text = "You can retrieve the current total number of unread messages by calling unreadMessageCountChanged on Messaging on your Zendesk SDK instance."

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
