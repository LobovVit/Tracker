//
//  AdditionViewComtroller.swift
//  Tracker
//
//  Created by Vitaly Lobov on 28.12.2024.
//

import UIKit

final class AdditionViewComtroller: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    
    private lazy var newHabitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapNewHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "newHabitBtn"
        return button
    }()
    
    private lazy var newIrregularBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapNewIrregularBtn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "newIrregularBtn"
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        view.backgroundColor = .white
        addHabitBtn(button: newHabitBtn)
        addIrregularBtn(button: newIrregularBtn)
        addLabel(label: label)
    }
    
    @objc
    private func didTapNewHabit() {
        let vc = HabitViewController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    @objc
    private func didTapNewIrregularBtn() {
        let vc = IrregularViewController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: message,
                message: message,
                buttonText: "Да",
                completion: { self.dismiss(animated: true) }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    private func addHabitBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -40),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addIrregularBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40),
                                     button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
}
