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

    func testTrackersViewControllerSnapshot() {
        let ob = OnboardingImagesViewController()
        let vc = TrackersViewController()
        let navController = UINavigationController(rootViewController: vc)
        ob.didTapLoadBtn()
        navController.loadViewIfNeeded()
        navController.view.layoutIfNeeded()
        withSnapshotTesting {
            assertSnapshot(of: navController, as: .image, record: false) // Менять `record` на `true`, если нужно обновить снимок
        }
    }
}
