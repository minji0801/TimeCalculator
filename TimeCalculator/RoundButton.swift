//
//  RoundButton.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/27.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 3
                self.layer.shadowColor = UIColor.darkGray.cgColor
                self.layer.shadowOpacity = 0.1
                self.layer.shadowOffset = CGSize.init(width: 5, height: 5)
                self.layer.shadowRadius = 10
            }
        }
    }
}
