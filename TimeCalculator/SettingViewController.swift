//
//  SettingViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/17.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [darkModeButton, soundButton, reviewButton, feedbackButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.label.cgColor
        }
    }
    
}
