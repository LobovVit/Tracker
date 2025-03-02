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
            title: "Trackers".localized,
            image: UIImage(named: "tracker_ico_active"),
            selectedImage: nil
        )
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Statistics".localized,
            image: UIImage(named: "stats_ico_active"),
            selectedImage: nil
        )
        self.viewControllers = [trackerViewController, statsViewController]
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.separator.cgColor
        self.tabBar.backgroundColor = .backgroundColor
    }
}

extension TabBarViewController{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTheme()
        }
    }
    
    private func updateTheme() {
        tabBar.backgroundColor = .backgroundColor
        tabBar.layer.borderColor = UIColor.separator.cgColor
    }
}
