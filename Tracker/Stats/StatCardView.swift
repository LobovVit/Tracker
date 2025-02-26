//
//  StatCardView.swift
//  Tracker
//
//  Created by Vitaly Lobov on 26.02.2025.
//

import UIKit

final class StatCardView: UIView {
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let gradientBorder = CAGradientLayer()
    private let borderMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradientBorder()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true

        addSubview(valueLabel)
        addSubview(titleLabel)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(value: Int, title: String) {
        valueLabel.text = "\(value)"
        titleLabel.text = title
    }

    private func applyGradientBorder() {
        gradientBorder.frame = bounds
        gradientBorder.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientBorder.startPoint = CGPoint(x: 0, y: 0)
        gradientBorder.endPoint = CGPoint(x: 1, y: 1)

        let cornerRadius: CGFloat = 15
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius).cgPath

        borderMask.path = path
        borderMask.lineWidth = 2
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = UIColor.black.cgColor

        gradientBorder.mask = borderMask
        layer.addSublayer(gradientBorder)
    }
}
