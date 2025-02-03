//
//  AdditionCollectionView.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.01.2025.
//

import UIKit

class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(colorView)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 36),
            colorView.heightAnchor.constraint(equalToConstant: 36),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        contentView.layer.borderWidth = isSelected ? 3 : 0
        contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : nil
        contentView.layer.cornerRadius = isSelected ? 8 : 0
        contentView.layer.masksToBounds = isSelected
    }
}

class EmojiCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiCell"
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(emojiLabel)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? .lightGray : .clear
    }
}

