//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.01.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    weak var delegate: TrackerCellDelegate?
    var currentDate: Date?
    var trackerId: UUID?
    private var isCompletedToday = false
    private var indexPath: IndexPath?
    
    private let imageView: UIView = {
        let imageView = UIView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.isHidden = false
        return imageView
    }()
    
    private let emojiView: UILabel = {
        let emojiView = UILabel()
        emojiView.textAlignment = .left
        emojiView.font = .systemFont(ofSize: 24)
        return emojiView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var executeBtn: UIButton = {
        let executeBtn = UIButton()
        executeBtn.layer.cornerRadius = 17
        executeBtn.layer.masksToBounds = true
        executeBtn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return executeBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(emojiView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(executeBtn)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        executeBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -60),
            
            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            emojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -66),
            
            executeBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            executeBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            executeBtn.widthAnchor.constraint(equalToConstant: 34),
            executeBtn.heightAnchor.constraint(equalToConstant: 34),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Tracker, completedDay: Int, isCompletedToday: Bool, indexPath: IndexPath) {
        self.trackerId = item.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        emojiView.text = item.emoji
        nameLabel.text = item.name
        imageView.backgroundColor = item.color
        let word = dayWord(for: completedDay)
        countLabel.text = "\(completedDay) \(word)"
        executeBtn.backgroundColor = item.color
        if isCompletedToday  {
            executeBtn.setImage(UIImage(named: "Done"), for: .normal)
        } else {
            executeBtn.setImage(UIImage(named: "Plus"), for: .normal)
        }
    }
    
    func dayWord(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "дней"
        }
        switch lastDigit {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
    
    @objc private func buttonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
