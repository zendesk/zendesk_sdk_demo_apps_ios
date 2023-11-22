//
//  MetadataFieldsCell.swift
//  Metadata
//
//  Created by Ajoly on 22/11/2023.
//

import UIKit
import ZendeskSDK

class FieldsCell: UITableViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var addFieldsButton: UIButton!
    @IBOutlet weak var clearFieldsButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var addHandler: (() -> Void)?
    var clearHandler: (() -> Void)?

    @IBOutlet weak var stackView: UIStackView!


    override func awakeFromNib() {
        super.awakeFromNib()
        styling()
    }


    @IBAction func addButtonClicked(_ sender: Any) {
        addHandler?()

    }

    @IBAction func clearButtonClicked(_ sender: Any) {
        clearHandler?()
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

        cardDescription.text = "The Zendesk SDK allows values for conversation fields to be set in the SDK to add contextual data about the conversation."

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

        self.addFieldsButton.backgroundColor = UIColor(named: "cardButtonColor")
        self.addFieldsButton.titleLabel?.tintColor = UIColor(named: "cardButtonLabelColor")
        self.addFieldsButton.layer.cornerRadius = 14

        self.clearFieldsButton.backgroundColor = UIColor(named: "logOutButtonColor")
        self.clearFieldsButton.titleLabel?.tintColor = UIColor(named: "cardButtonColor")
        self.clearFieldsButton.layer.cornerRadius = 14

        self.backgroundView = backgroundView

    }

}
