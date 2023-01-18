//
//  SceneDelegate.swift
//  AuthorizationForm
//
//  Created by Александр Меренков on 4/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let viewController = AuthorizationViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

