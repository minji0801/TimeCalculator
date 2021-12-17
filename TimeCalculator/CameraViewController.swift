//
//  CameraViewController.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/14.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppearanceCheck(self)
    }

}
