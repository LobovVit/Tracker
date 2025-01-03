//
//  OnboardingVIewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class OnboardingVIewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        if OnboardingLaunchedEarlier.shared.didAppStart {
            let tabBarController = TabBarViewController()
            window.rootViewController = tabBarController
        } else {
            OnboardingLaunchedEarlier.shared.didAppStart = true
            let onboardingImagesViewController = OnboardingImagesViewController()
            window.rootViewController = onboardingImagesViewController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchToTabBarController()
    }
}
