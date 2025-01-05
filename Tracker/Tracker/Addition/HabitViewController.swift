//
//  HabitViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.12.2024.
//

import UIKit

final class HabitViewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15;
        button.layer.borderColor = .init(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.0)
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "saveBtn"
        return button
    }()
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15;
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "cancelBtn"
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 15;
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .ypGray
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.font = .systemFont(ofSize: .init(17), weight: .regular)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "nameTextField"
        return textField
    }()
    
    private lazy var categoryBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: .init(17), weight: .regular)
        button.setImage(UIImage(named: "drill_down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 80, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapCategory), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "categoryBtn"
        return button
    }()
    
    private lazy var sceduleBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расписание", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: .init(17), weight: .regular)
        button.setImage(UIImage(named: "drill_down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 80, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(didTapScedule), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "sceduleBtn"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        view.backgroundColor = .white
        addNameTextField(textField: nameTextField)
        addLabel(label: label)
        addSaveBtn(button: saveBtn)
        addCancelBtn(button: cancelBtn)
        addCategoryBtn(button: categoryBtn)
        addSceduleBtn(button: sceduleBtn)
    }
    
    @objc
    private func didTapSave() {
        showAlert(message: "Сохранить привычку")
    }

    @objc
    private func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func didTapCategory() {
        let vc = CategorysViewController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    @objc
    private func didTapScedule() {
        let vc = SceduleViewController()
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
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addSaveBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: view.frame.width / 4 - 5),
                                     button.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 25),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addCancelBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: (view.frame.width / 4 - 5) * -1 ),
                                     button.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 25),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addNameTextField(textField: UITextField) {
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                                     textField.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addCategoryBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 190),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addSceduleBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
}
