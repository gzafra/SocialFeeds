//
//  UIAlertControllerExtensions.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    public static func showAlert(withMessage message: String, title: String = "", fromController controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}
