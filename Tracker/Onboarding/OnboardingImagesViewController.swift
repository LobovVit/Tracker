//
//  OnboardingImagesViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 03.01.2025.
//

import UIKit

final class OnboardingImagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private let images = ["ypBg1", "ypBg2"]
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var goBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Вот это технологии", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapGoBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "goBtn"
        return btn
    }()
    
    private lazy var loadBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("очистить БД и загрузить тестовые данные", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapLoadBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "loadBtn"
        return btn
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = images.count
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.accessibilityIgnoresInvertColors = true
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .black
        if let firstVC = viewControllerForImage(at: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        addGoBtn(button: goBtn)
    //    addLoadBtn(button: loadBtn)
        addPageControl(pageControl: pageControl)
    }
    
    @objc
    private func didTapGoBtn() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    private func didTapLoadBtn() {
        trackerCategoryStore.clearCoreData(for: "TrackerCoreData")
        trackerCategoryStore.clearCoreData(for: "TrackerCategoryCoreData")
        trackerCategoryStore.clearCoreData(for: "TrackerRecordCodeData")
//        for tracker in MockData.mockData[...] {
//            do {
//                try trackerCategoryStore.updateTrackerCategory(tracker)
//            } catch {
//                print("ERR: in trackerCategoryStore.addNewTrackerCategory")
//            }
//        }
        
    }
    
    private func viewControllerForImage(at index: Int) -> UIViewController? {
        guard index >= 0 && index < images.count else { return nil }
        let imageVC = ImageViewController()
        imageVC.imageName = images[index]
        imageVC.view.tag = index
        pageControl.currentPage = index
        return imageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        return viewControllerForImage(at: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = viewController.view.tag
        return viewControllerForImage(at: currentIndex + 1)
    }
    
    private func addGoBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addLoadBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addPageControl(pageControl: UIPageControl) {
        self.view.addSubview(pageControl)
        NSLayoutConstraint.activate([pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110)])
    }
}

