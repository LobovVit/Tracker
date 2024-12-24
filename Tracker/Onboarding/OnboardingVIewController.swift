//
//  OnboardingVIewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class OnboardingVIewController: UIViewController {
    private var isFirstEnter: Bool = false
    private var alertPresenter: AlertPresenting?
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchToTabBarController()
    }
}
