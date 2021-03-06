//
//  SceneDelegate.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 10/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = scene as? UIWindowScene else { return }
    
    Profile.synchronize()
    let dataProfile = Profile.objProfile
    if dataProfile.name.isEmpty || dataProfile.numberPhone.isEmpty || dataProfile.email.isEmpty {
      Profile.objProfile = Profile(name: "Budi Darmawan", numberPhone: "082211112222", email: "budi@buaya.com")
    }
    
    let games = GamesViewController(nibName: "GamesViewController", bundle: nil)
    games.title = "Games"
    games.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)
    
    let bookmarks = BookmarksViewController(nibName: "BookmarksViewController", bundle: nil)
    bookmarks.title = "Bookmarks"
    bookmarks.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark.fill"), tag: 1)
    
    let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
    profile.title = "Profile"
    profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
    
    let tabBar = TabBarController(nibName: "TabBarController", bundle: nil)
    tabBar.viewControllers = [
      makeNavigation(vc: games),
      makeNavigation(vc: bookmarks),
      makeNavigation(vc: profile)
    ]
    
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.rootViewController = tabBar
    window?.makeKeyAndVisible()
    window?.backgroundColor = .systemBackground
  }
  
  func makeNavigation(vc: UIViewController) -> UINavigationController {
    let navigation = UINavigationController(rootViewController: vc)
    navigation.navigationBar.prefersLargeTitles = true
    return navigation
  }
  
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

