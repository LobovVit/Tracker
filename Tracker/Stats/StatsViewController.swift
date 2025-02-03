//
//  StatsViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(34), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "smile")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(18), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLabel(label: label)
        addImage(image: image)
        addEmptyLabel(label: emptyLabel)
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
        self.view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 55)])
    }

}
