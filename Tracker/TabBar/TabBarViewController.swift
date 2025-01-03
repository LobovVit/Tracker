//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackerViewController = TrackersViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tracker_ico_active"),
            selectedImage: nil
        )
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "stats_ico_active"),
            selectedImage: nil
        )
        self.viewControllers = [trackerViewController, statsViewController]
        self.tabBar.layer.borderWidth = 1
    }
}
