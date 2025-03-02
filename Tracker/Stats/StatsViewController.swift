//
//  StatsViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private var perfectStreak: Int = 0
    private var perfectDays: Int = 0
    private var trackersCompleteCount: Int = 0
    
    private let trackerRecordStore = TrackerRecordStore()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Statistics".localized
        label.textColor = .textColor
        label.font = .systemFont(ofSize: .init(34), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "smile")
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "There is nothing to analyze yet".localized
        label.textColor = .textColor
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var perfectStreakCard: StatisticsCardView = {
        let card = StatisticsCardView()
        card.configure(value: perfectStreak, title: "Best period".localized)
        return card
    }()
    
    private lazy var perfectDaysCard: StatisticsCardView = {
        let card = StatisticsCardView()
        card.configure(value: perfectDays, title: "Perfect Days".localized)
        return card
    }()
    
    private lazy var trackersCompleteCountCard: StatisticsCardView = {
        let card = StatisticsCardView()
        card.configure(value: trackersCompleteCount, title: "Trackers completed".localized)
        return card
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(calculateStats), name: .NSManagedObjectContextDidSave, object: nil)
        addLabel(label: label)
        addStackView(stackView: stackView)
        addEmptyLabel(label: emptyLabel)
        addImage(image: image)
        updateTheme()
    }
    
    @objc private func calculateStats() {
        trackersCompleteCount = trackerRecordStore.completedTrackers()
        perfectDays = trackerRecordStore.countPerfectDays()
        perfectStreak = trackerRecordStore.longestPerfectStreak()
        perfectStreakCard.configure(value: perfectStreak, title: "Best period".localized)
        perfectDaysCard.configure(value: perfectDays, title: "Perfect Days".localized)
        trackersCompleteCountCard.configure(value: trackersCompleteCount, title: "Trackers completed".localized)
        stackView.addArrangedSubview(perfectStreakCard)
        stackView.addArrangedSubview(perfectDaysCard)
        stackView.addArrangedSubview(trackersCompleteCountCard)
        if perfectStreak + perfectDays + trackersCompleteCount > 0 {
            stackView.isHidden = false
            emptyLabel.isHidden = true
            image.isHidden = true
        } else {
            stackView.isHidden = true
            emptyLabel.isHidden = false
            image.isHidden = false
        }
    }
    
    private func addStackView(stackView: UIStackView) {
        calculateStats()
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addImage(image: UIImageView) {
        view.addSubview(image)
        NSLayoutConstraint.activate([image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     image.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
                                     image.widthAnchor.constraint(equalToConstant: 80),
                                     image.heightAnchor.constraint(equalToConstant: 80)])
        
    }
    
    private func addEmptyLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 55)])
    }
    
}

extension StatsViewController{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTheme()
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = .backgroundColor
        label.textColor = .textColor
        emptyLabel.textColor = .textColor
    }
}
