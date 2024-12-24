//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(34), weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.accessibilityIdentifier = "DatePicker"
        return datePicker
    }()
    
    private lazy var plusBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus_ico")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "PlusBtn"
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "🔍 Поиск"
        textField.backgroundColor = .ypGray
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: .init(17), weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(18), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        addLabel(label: label)
        addDatePicker(datePicker: datePicker)
        addPlusBtn(button: plusBtn)
        addTextField(textField: textField)
        addImage(imageView: imageView)
        addEmptyLabel(label: emptyLabel)
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addDatePicker(datePicker: UIDatePicker) {
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                                     datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     datePicker.widthAnchor.constraint(equalToConstant: 100),
                                     datePicker.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func addPlusBtn(button: UIButton) {
        view.addSubview(button)
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     button.widthAnchor.constraint(equalToConstant: 44),
                                     button.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func addTextField(textField: UITextField) {
        view.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                                     textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                                     textField.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func addImage(imageView: UIImageView) {
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
                                     imageView.widthAnchor.constraint(equalToConstant: 80),
                                     imageView.heightAnchor.constraint(equalToConstant: 80)])
    }
    
    private func addEmptyLabel(label: UILabel) {
        self.view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 55)])
    }
    
    @objc
    private func didTapButton() {
        showAlert()
    }
    
    private func showAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Что то добавить?",
                message: "Что то добавить?",
                buttonText: "Да",
                completion: { self.dismiss(animated: true) },
                secondButtonText: "Нет",
                secondCompletion: { self.dismiss(animated: true) }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }

}
