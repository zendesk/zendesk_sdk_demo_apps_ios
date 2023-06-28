//
//  InitializeSDKCardCell.swift
//  hello_world
//
//  Created by Andrew Dietrich on 3/7/23.
//

import UIKit


class RegisterPushCardCell: UITableViewCell {
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    var clickHandler: (() -> Void)?
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styling()
        initTextView(interfaceStyleLight: self.traitCollection.userInterfaceStyle == .light)
    }
    
    @IBAction func callToAction(_ sender: Any) {
        
        clickHandler?()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                self.contentView.layer.backgroundColor = UIColor.white.cgColor
                initTextView(interfaceStyleLight: true)
            } else {
                self.contentView.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
                self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
                initTextView(interfaceStyleLight: false)
            }
        }
    }
    
    func initTextView(interfaceStyleLight: Bool? = true) {
        
        
        let fullText = "The Zendesk SDK supports APNS for push notifications. See instructions for setting up push notifications in your app."
        let nonCLickableString = "The Zendesk SDK supports APNS for push notifications. "
        let clickableString = "See instructions for setting up push notifications in your app."
        let linkString = NSMutableAttributedString(string: fullText)
        let linkRange = NSRange(location: nonCLickableString.count, length: clickableString.count)
        let fullRange = NSRange(location: 0, length: fullText.count)
        
        linkString.addAttribute(.link, value: "https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/push_notifications/", range: linkRange)
        linkString.addAttribute(.underlineStyle, value: 1, range: linkRange)
        
        if interfaceStyleLight == true {
            linkString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: fullRange)
            cardDescription.linkTextAttributes = [.foregroundColor: UIColor.black]
        } else {
            linkString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: fullRange)
            cardDescription.linkTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        cardDescription.attributedText = linkString
        cardDescription.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    func styling() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.layer.cornerRadius = 14
        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 14
        self.contentView.layer.masksToBounds = true
        
        let backgroundView = UIView.init(frame: contentView.frame)
        backgroundView.backgroundColor = UIColor.clear
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
                self.contentView.layer.backgroundColor = UIColor.white.cgColor
                initTextView(interfaceStyleLight: true)
            } else {
                self.contentView.layer.borderColor = UIColor(named: "cardBorderColor")?.cgColor
                self.contentView.layer.backgroundColor = UIColor(named: "cardBackgroundColor")?.cgColor
                initTextView(interfaceStyleLight: false)
            }
        }
        
        self.registerButton.backgroundColor = UIColor(named: "cardButtonColor")
        self.registerButton.titleLabel?.tintColor = UIColor(named: "cardButtonLabelColor")
        self.registerButton.layer.cornerRadius = 14
        
        self.backgroundView = backgroundView
    }
    
}


