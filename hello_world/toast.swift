//
//  toast.swift
//  hello_world
//
//  Created by Andrew Dietrich on 2/3/23.
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
    }
