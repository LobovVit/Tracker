//
//  Untitled.swift
//  Tracker
//
//  Created by Vitaly Lobov on 01.02.2025.
//

import UIKit

class DetailButton: UIButton {
    let detailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDetailLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDetailLabel()
    }
    
    private func setupDetailLabel() {
        detailLabel.font = UIFont.systemFont(ofSize: 17)
        detailLabel.textColor = .gray
        detailLabel.textAlignment = .center
        addSubview(detailLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            detailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
    }
    
    func setDetailText(_ text: String) {
        detailLabel.text = text
    }
}
