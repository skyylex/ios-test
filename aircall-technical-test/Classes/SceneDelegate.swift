//
//  SceneDelegate.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 06/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var router: ActivityFeedRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navigationVC = UINavigationController(rootViewController: UIViewController())
        
        router = ActivityFeedRouter(navigationController: navigationVC)
        router?.start()
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }

}

