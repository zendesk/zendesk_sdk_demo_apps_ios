//
//  InitializeSDKCardCell.swift
//  hello_world
//
//  Created by Andrew Dietrich on 3/7/23.
//

import UIKit


class PageViewCardCell: UITableViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
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

        cardDescription.text = "The Visitor Path lets agents see what screen the end user had landed on, for better conversation context. A PageView object encapsulates information related to a user's interactions and passes it to the Page View Event API."

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

        self.backgroundView = backgroundView
    }

}
