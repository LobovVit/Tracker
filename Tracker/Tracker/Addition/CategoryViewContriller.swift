//
//  CategoryViewContriller.swift
//  Tracker
//
//  Created by Vitaly Lobov on 06.01.2025.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSaveCategory(_ category: String)
}

final class CategoryViewController: UIViewController {
    
    private var categoryName: String?
    weak var delegate: CategoryViewControllerDelegate?
    
    init(categoryName: String? = nil) {
        self.categoryName = categoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        if let categoryName {
            label.text = "Редактирование категории"
        } else {
            label.text = "Новая категория"
        }
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var okBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        if let categoryName {
            button.backgroundColor = .black
            button.isEnabled = true
        } else {
            button.backgroundColor = .gray
            button.isEnabled = false
        }
        button.layer.cornerRadius = 15;
        button.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "additionBtn"
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if let categoryName {
            textField.text = categoryName
        } else {
            textField.placeholder = "Введите название категории"
        }
        textField.layer.cornerRadius = 15;
        textField.layer.masksToBounds = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addLabel(label: label)
        addOkBtn(button: okBtn)
        addNameTextField(textField: nameTextField)
    }
    
    @objc
    private func didTapOk() {
        delegate?.didSaveCategory(nameTextField.text ?? "")
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addOkBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addNameTextField(textField: UITextField) {
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                                     textField.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            okBtn.isEnabled = false
            okBtn.backgroundColor = .gray
        } else {
            let text = textField.text ?? ""
            okBtn.isEnabled = text.count>0
            okBtn.backgroundColor = text.count>0 ? .black : .gray
            nameTextField.clearButtonMode = text.count>0 ? .whileEditing : .never
        }
    }
    
}
