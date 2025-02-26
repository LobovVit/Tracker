//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Vitaly Lobov on 22.12.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    
    let isRecordingMode = false // Менять на `true`, если нужно обновить снимки
    
    func testTrackersViewController_LightMode() {
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        let vc = UINavigationController(rootViewController: TrackersViewController())
        let ob = OnboardingImagesViewController()
        ob.didTapLoadBtn()
        vc.loadViewIfNeeded()
        withSnapshotTesting {
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: isRecordingMode)
        }
    }
    
    func testTrackersViewController_DarkMode() {
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        let vc = UINavigationController(rootViewController: TrackersViewController())
        let ob = OnboardingImagesViewController()
        ob.didTapLoadBtn()
        vc.loadViewIfNeeded()
        withSnapshotTesting {
            assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: isRecordingMode)
        }
    }
    
}
