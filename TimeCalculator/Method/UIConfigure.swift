//
//  UIConfigure.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/17.
//

import Foundation
import UIKit

// UserDefaults에 저장된 값을 통해 다크모드 확인하는 메소드
func appearanceCheck(_ viewController: UIViewController) {
    let appearance = UserDefaults.standard.bool(forKey: "Dark")

    if appearance {
        viewController.overrideUserInterfaceStyle = .dark
    } else {
        viewController.overrideUserInterfaceStyle = .light
    }

    if #available(iOS 13.0, *) {
        if appearance {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    } else {
        UIApplication.shared.statusBarStyle = .default
    }
}
