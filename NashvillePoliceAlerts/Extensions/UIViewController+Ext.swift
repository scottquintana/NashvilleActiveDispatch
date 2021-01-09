//
//  UIViewController+Ext.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/7/21.
//

import UIKit

extension UIViewController {
    func presentADAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = ADAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
