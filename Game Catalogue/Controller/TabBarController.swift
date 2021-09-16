//
//  TabBarController.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 10/07/21.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gamesViewController = GamesViewController()
    
    gamesViewController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)
    
    viewControllers =  [gamesViewController]
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
