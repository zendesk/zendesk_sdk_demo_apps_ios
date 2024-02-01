//
//  UIViewController+Extension.swift
//
//  Copyright © 2023 Zendesk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message,
                                      preferredStyle: .actionSheet)
        alert.view.layer.cornerRadius = 15
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
    func insertGradientLayer(_ gradientLayer: CAGradientLayer, backgroundView: UIView) {
        let backgroundColor = UIColor(named: "backgroundColor")
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, backgroundColor!.cgColor]
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        okButton.setValue(UIColor(named: "cardButtonColor"), forKey: "titleTextColor")
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
