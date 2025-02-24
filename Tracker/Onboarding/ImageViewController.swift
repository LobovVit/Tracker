//
//  ImageViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 03.01.2025.
//

import UIKit

final class ImageViewController: UIViewController {
    var imageName: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .init(32), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Вот это технологии", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(didTapGoBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "goBtn"
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
            if imageName == "ypBg1"  {
                addLabel(label: label, text: "Отслеживайте только то что хотите")
            } else {
                addLabel(label: label, text: "Даже если это не литры воды и йога")
            }
        }
        addGoBtn(button: goBtn)
    }
    
    @objc
    private func didTapGoBtn() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func addLabel(label: UILabel, text: String) {
        label.text = text
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 50),
                                     label.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)])
    }
    
    private func addGoBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
}
