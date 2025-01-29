//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.01.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    private let imageView: UILabel = {
        let imageView = UILabel()
        imageView.textAlignment = .center
        imageView.font = .systemFont(ofSize: 34)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Tracker) {
        imageView.text = item.emoji
        nameLabel.text = item.name
        contentView.backgroundColor = item.color
    }
}


