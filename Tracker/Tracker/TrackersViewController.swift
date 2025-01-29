//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    var categories: [TrackerCategory] = [TrackerCategory(name: "Моя Категория",
                                                         trackers: [Tracker(id: UUID.init(),
                                                                            name: "Google1",
                                                                            color: .C_1,
                                                                            emoji: "😻",
                                                                            scheduler: Schedule(mon: false,
                                                                                                tue: false,
                                                                                                wed: false,
                                                                                                thu: false,
                                                                                                fri: false,
                                                                                                sat: false,
                                                                                                sun: true)
                                                                           ),
                                                                    Tracker(id: UUID.init(),
                                                                                       name: "Google1",
                                                                                       color: .C_3,
                                                                                       emoji: "😻",
                                                                                       scheduler: Schedule(mon: false,
                                                                                                           tue: false,
                                                                                                           wed: false,
                                                                                                           thu: false,
                                                                                                           fri: false,
                                                                                                           sat: false,
                                                                                                           sun: true)
                                                                             )
                                                                    ]
                                                        ),
                                         TrackerCategory(name: "Не моя категория",
                                                         trackers: [Tracker(id: UUID.init(),
                                                                            name: "Google3",
                                                                            color: .C_2,
                                                                            emoji: "😻",
                                                                            scheduler: Schedule(mon: false,
                                                                                                tue: false,
                                                                                                wed: false,
                                                                                                thu: false,
                                                                                                fri: false,
                                                                                                sat: false,
                                                                                                sun: true)
                                                                           )
                                                                    ]
                                                         )
                                         ]
    var completedTrackers: [TrackerRecord] = []
    
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
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
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
    
    private lazy var textField: UISearchBar = {
        let textField = UISearchBar()
        textField.placeholder = "Поиск"
        textField.layer.cornerRadius = 15;
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.backgroundImage = UIImage()
        textField.searchTextField.backgroundColor = .clear
        textField.backgroundColor = .ypGray
        textField.layer.borderColor = UIColor.ypGray.cgColor
        textField.searchTextField.font = .systemFont(ofSize: .init(17), weight: .regular)
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        addLabel(label: label)
        addDatePicker(datePicker: datePicker)
        addPlusBtn(button: plusBtn)
        addTextField(textField: textField)
        if categories.isEmpty {
            addImage(imageView: imageView)
            addEmptyLabel(label: emptyLabel)
        } else {
            addCollectionView(collection: collectionView)
        }
        
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addDatePicker(datePicker: UIDatePicker) {
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     datePicker.widthAnchor.constraint(equalToConstant: 100),
                                     datePicker.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func addPlusBtn(button: UIButton) {
        view.addSubview(button)
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     button.widthAnchor.constraint(equalToConstant: 44),
                                     button.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func addTextField(textField: UISearchBar) {
        view.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func addCollectionView(collection: UICollectionView) {
        view.addSubview(collection)
        NSLayoutConstraint.activate([collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                                     collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                                     collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170),
                                     collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)])
    }
    
    @objc
    private func didTapButton() {
        let vc = AdditionViewComtroller()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
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

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as! TrackerCell
        let item = categories[indexPath.section].trackers[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        header.configure(with: categories[indexPath.section].name)
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
