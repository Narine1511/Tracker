//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 19.06.2026.
//

/*import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let trackers = ViewController()
        trackers.tabBarItem = UITabBarItem(
         title: "Трекеры",
         image: UIImage(named: "trackerTabBarItem"),
         tag: 0)
        
        let statistic = StatisticsViewController()
        statistic.tabBarItem = UITabBarItem(
         title: "Статистика",
         image: UIImage(named: "statisticTabBarItem"),
         tag: 1)
        
        
        
        let trackersNav = UINavigationController(rootViewController: trackers)
        let statisticNav = UINavigationController(rootViewController: statistic)
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackersNav, statisticNav]
        self.tabBarController = tabBarController
        
        window = UIWindow(windowScene: windowScene)
        
        /*let onboardingVC = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )*/
        let isOnboardingShown = UserDefaults.standard.bool(forKey: "isOnboardingShown")
        
        if isOnboardingShown {
            window?.rootViewController =
        } else {
            let onboardingVC = OnboardingViewController(
                            transitionStyle: .scroll,
                            navigationOrientation: .horizontal
                        )

            window?.rootViewController = onboardingVC
        }
        
        /*window?.rootViewController = tabBarController
        window?.rootViewController = onboardingVC*/
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}
*/


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let mainViewController = createMainViewController()
        let isOnboardingShow = UserDefaults.standard.bool(forKey: "isOnboardingShown")
        
        if isOnboardingShow {
            window?.rootViewController = mainViewController
        } else {
            let onboardingVC = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            onboardingVC.sceneDelegate = self
            window?.rootViewController = onboardingVC
        }
        window?.makeKeyAndVisible()
    }
    
    
    private func createMainViewController() -> UITabBarController {
        let trackers = ViewController()
        trackers.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerTabBarItem"),
            tag: 0)
        
        let statistic = StatisticsViewController()
        statistic.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statisticTabBarItem"),
            tag: 1)
        
        let trackersNav = UINavigationController(rootViewController: trackers)
        let statisticNav = UINavigationController(rootViewController: statistic)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.layer.borderColor = UIColor.ypGray1.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.viewControllers = [trackersNav, statisticNav]
        
        return tabBarController
    }
    
    func showMainApp() {
        print("🟢 showMainApp() ВЫЗВАН")
        window?.rootViewController = createMainViewController()
        window?.makeKeyAndVisible()
    }
}
