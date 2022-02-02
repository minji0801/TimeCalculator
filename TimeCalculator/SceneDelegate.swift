//
//  SceneDelegate.swift
//  TimeCalculator
//
//  Created by 김민지 on 2021/12/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
//        guard let _ = (scene as? UIWindowScene) else { return }
        guard (scene as? UIWindowScene) != nil else { return }
    }
}
