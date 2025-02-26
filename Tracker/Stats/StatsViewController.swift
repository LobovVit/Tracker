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
        label.text = "Статистика"
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
        label.text = "Анализировать пока нечего"
        label.textColor = .textColor
        label.font = .systemFont(ofSize: .init(18), weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var card1: StatCardView = {
        let card = StatCardView()
        card.configure(value: perfectStreak, title: "Лучший период")
        return card
    }()

    private lazy var card2: StatCardView = {
        let card = StatCardView()
        card.configure(value: perfectDays, title: "Идеальные дни")
        return card
    }()

    private lazy var card3: StatCardView = {
        let card = StatCardView()
        card.configure(value: trackersCompleteCount, title: "Трекеров завершено")
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
        NotificationCenter.default.addObserver(self, selector: #selector(calculateStsts), name: .NSManagedObjectContextDidSave, object: nil)
        addLabel(label: label)
        addStackView(stackView: stackView)
        addEmptyLabel(label: emptyLabel)
        addImage(image: image)
    }
    
    @objc private func calculateStsts() {
        trackersCompleteCount = trackerRecordStore.completedTrackers()
        perfectDays =  trackerRecordStore.countPerfectDays()
        perfectStreak = trackerRecordStore.longestPerfectStreak()
        card1.configure(value: perfectStreak, title: "Лучший период")
        card2.configure(value: perfectDays, title: "Идеальные дни")
        card3.configure(value: trackersCompleteCount, title: "Трекеров завершено")
        if perfectStreak + perfectDays + trackersCompleteCount > 0 {
            stackView.addArrangedSubview(card1)
            stackView.addArrangedSubview(card2)
            stackView.addArrangedSubview(card3)
        } else {
            emptyLabel.isHidden = false
            image.isHidden = false
        }
    }
    
    private func addStackView(stackView: UIStackView) {
        calculateStsts()
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
