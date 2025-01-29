//
//  IrregularViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 02.01.2025.
//

import UIKit

final class IrregularViewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Максимальное количество символов: 38"
        label.textColor = .ypRed
        label.font = .systemFont(ofSize: .init(16), weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = true
        button.layer.borderColor = .init(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.0)
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.isEnabled = false
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
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "cancelBtn"
        return button
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = "Введите название трекера"
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
    
    private lazy var categoryBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: .init(17), weight: .regular)
        button.setImage(UIImage(named: "drill_down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 15
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        view.backgroundColor = .white
        addScrollView(scrollView: scrollView, contentView: contentView)
        addNameTextField(textField: nameTextField)
        addLabel(label: label)
        addWarningLabel(label: warningLabel)
        addSaveBtn(button: saveBtn)
        addCancelBtn(button: cancelBtn)
        addCategoryBtn(button: categoryBtn)
        addCollectionView(collection: collectionView)
    }
    
    @objc
    private func didTapSave() {
        showAlert(message: "Сохранить событие")
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
    
    private func addCollectionView(collection: UICollectionView) {
        scrollView.addSubview(collection)
        NSLayoutConstraint.activate([collection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                                     collection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                                     collection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 160),
                                     collection.heightAnchor.constraint(equalToConstant: 450),
                                     collection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)])
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addScrollView(scrollView: UIScrollView, contentView: UIView) {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                                     scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                                     scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                                     scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)])
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                ])
    }
    
    private func addWarningLabel(label: UILabel) {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60)])
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
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                     textField.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addCategoryBtn(button: UIButton) {
        contentView.addSubview(button)
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 90),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            saveBtn.isEnabled = false
            saveBtn.backgroundColor = .gray
        } else {
            let text = textField.text ?? ""
            warningLabel.isHidden = !(text.count > 38)
            saveBtn.isEnabled = warningLabel.isHidden
            saveBtn.backgroundColor = warningLabel.isHidden ? .black : .gray
            nameTextField.clearButtonMode = text.count>0 ? .whileEditing : .never
        }
    }
    
}

extension IrregularViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        let item = sections[indexPath.section].items[indexPath.item]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.configure(with: sections[indexPath.section].title)
        return header
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 7
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

