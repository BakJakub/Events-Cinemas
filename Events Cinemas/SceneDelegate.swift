//Copyright (c) 2023 Jakub Bąk. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let eventsCinemasController = EventsCinemasController()
        let navigationController = UINavigationController(rootViewController: eventsCinemasController)
        window.rootViewController = navigationController
        
        coordinator = Coordinator(navigationController: navigationController)
        eventsCinemasController.coordinator = coordinator
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
