//
//  font15Button.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/28.
//

import UIKit

@IBDesignable
class SettingButton: UIButton {
    @IBInspectable var isSetting: Bool = false {
        didSet {
            if isSetting {
                self.titleLabel?.font = UIFont(name: "SDSamliphopangcheTTFBasic", size: 14)
                self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.titleLabel?.textAlignment = .center
            }
        }
    }
}
