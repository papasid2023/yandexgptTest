//
//  TabBarViewController.swift
//  aitest
//
//  Created by Руслан Сидоренко on 30.05.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let nav1 = UINavigationController(rootViewController: ViewController())
    let nav2 = UINavigationController(rootViewController: PdfViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        tabBar.isTranslucent = true
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.addSubview(blurView)
        
        
        nav1.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "PDF", image: UIImage(systemName: "house.fill"), tag: 2)
        
        
        setViewControllers([nav1, nav2], animated: true)
        
    }
    
}
