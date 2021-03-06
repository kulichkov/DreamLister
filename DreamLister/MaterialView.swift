//
//  MaterialView.swift
//  DreamLister
//
//  Created by Mikhail Kulichkov on 07/02/17.
//  Copyright © 2017 Mikhail Kulichkov. All rights reserved.
//

import UIKit

private var _materialKey = false

extension UIView {
    @IBInspectable var materialDesign: Bool {
        get {
            return _materialKey
        }
        set {
            _materialKey = newValue
            if _materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
            }
        }
    }
}
