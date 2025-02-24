//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.12.2024.
//

import UIKit
import SwiftUI

protocol SaveTrackerDelegate: AnyObject {
    func didSaveTracker(_ tracker: Tracker, _ category: String)
    func didTapCancelButton()
    func getCategorys() -> [String]
}

final class NewTrackerViewController: UIViewController, ScheduleViewControllerDelegate {
    
    private var alertPresenter: AlertPresenting?
    private var typeTracker: AdditionType
    private var isEdit: Bool = false
    private var tracker: Tracker
    private var trackerCategory: String?
    
    weak var saveTrackerDelegate: SaveTrackerDelegate?
    
    private var schedule: [DayOfWeek?] = []
    
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    private var emoji: String?
    private var color: UIColor?
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪" ]
    private let colors: [UIColor] = [
        .C_1, .C_2, .C_3, .C_4, .C_5, .C_6, .C_7, .C_8, .C_9, .C_10, .C_11, .C_12, .C_13, .C_14, .C_15, .C_16, .C_17, .C_18 ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        
        let itemWidth = (UIScreen.main.bounds.width - 106) / 6
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 34)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
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
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Максимальное количество символов – 38"
        label.textColor = .ypRed
        label.font = .systemFont(ofSize: .init(16), weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        //button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
    private lazy var categoryBtn: DetailButton = {
        let button = DetailButton(type: .system)
        button.setTitle("Категория", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: .init(17), weight: .regular)
        button.setImage(UIImage(named: "drill_down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 15
        if typeTracker == .habit {
            button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
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
    
    private lazy var sceduleBtn: DetailButton = {
        let button = DetailButton(type: .system)
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
        button.addTarget(self, action: #selector(didTapSchedule), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "sceduleBtn"
        return button
    }()
    
    init(type: AdditionType, item: Tracker?, category: String?) {
        if type == .edit {
            self.isEdit = true
            guard let item else { fatalError("edit item cannot be empty") }
            self.tracker = item
            guard let category else { fatalError("edit category cannot be empty") }
            self.trackerCategory = category
            self.typeTracker = .habit
            color = item.color
            emoji = item.emoji
            if let emojiIndex = emojis.firstIndex(where: { $0 == item.emoji }) {
                self.selectedEmojiIndex = IndexPath(item: emojiIndex, section: 0)
            }
            if let colorIndex = colors.firstIndex(where: { $0 == item.color }) {
                self.selectedColorIndex = IndexPath(item: colorIndex, section: 1)
            }
        } else {
            typeTracker = type
            tracker = Tracker(id: UUID(), name: "", color: .clear, emoji: "", scheduler: [], isPinned: false)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        alertPresenter = AlertPresenter(viewController: self)
        addLabel(label: label)
        addSaveBtn(button: saveBtn)
        addCancelBtn(button: cancelBtn)
        addScrollView(scrollView: scrollView, contentView: contentView)
        addNameTextField(textField: nameTextField)
        addWarningLabel(label: warningLabel)
        addCategoryBtn(button: categoryBtn)
        if typeTracker == .habit {
            addSceduleBtn(button: sceduleBtn)
        }
        addCollectionView(collection: collectionView)
    }
    
    @objc
    private func didTapSave() {
        guard let color else {
            showAlert(message: "Выберите ЦВЕТ")
            return
        }
        guard let emoji else {
            showAlert(message: "Выберите EMOJI")
            return
        }
        guard let trackerCategory else {
            showAlert(message: "Выберите категорию")
            return
        }
        let newTracker = Tracker(id: tracker.id, name: nameTextField.text ?? "", color: color, emoji: emoji, scheduler: schedule.compactMap { $0 }, isPinned: false)
        saveTrackerDelegate?.didSaveTracker(newTracker, trackerCategory)
    }
    
    @objc
    private func didTapCancel() {
        saveTrackerDelegate?.didTapCancelButton()
    }
    
    @objc private func didTapCategorySwiftUI() {
        let store = TrackerCategoryStore()
        let viewModel = TrackerCategoryViewModel(categoryStore: store)
        
        let swiftUIView = TrackerCategoryView(
            viewModel: viewModel,
            trackerCategory: .constant(trackerCategory),
            onCategorySelected: { [weak self] category in
                self?.trackerCategory = category.name
                self?.didUpdateCategory(category.name ?? "Unknown")
            }
        )
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .formSheet
        present(hostingController, animated: true)
    }
    
    @objc
    private func didTapCategory() {
        let categoriesVC = CategoriesViewController()
            categoriesVC.onCategorySelected = { [weak self] selectedCategory in
                guard let self = self else { return }
                self.trackerCategory = selectedCategory
                self.didUpdateCategory(selectedCategory)
            }
            present(categoriesVC, animated: true)
    }
    
    @objc
    private func didTapSchedule() {
        let vc = SceduleViewController()
        vc.delegate = self
        vc.loadSelectedSchedule(from: schedule)
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: message,
                message: message,
                buttonText: "Ок",
                completion: {  }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    private func addCollectionView(collection: UICollectionView) {
        scrollView.addSubview(collection)
        if typeTracker == .habit {
            NSLayoutConstraint.activate([collection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                                         collection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                                         collection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 220),
                                         collection.heightAnchor.constraint(equalToConstant: 500),
                                         collection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)])
        } else {
            NSLayoutConstraint.activate([collection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                                         collection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                                         collection.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 160),
                                         collection.heightAnchor.constraint(equalToConstant: 500),
                                         collection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)])
        }
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        label.text = isEdit ? "Редактируем привычку" : "Новая привычка"
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
        NSLayoutConstraint.activate([contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
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
        button.isEnabled = isEdit
        button.backgroundColor = isEdit ? .black : .gray
        isEdit ? button.setTitle("Сохранить", for: .normal) : button.setTitle("Создать", for: .normal)
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
        textField.text = isEdit ? tracker.name : ""
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                                     textField.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addCategoryBtn(button: DetailButton) {
        contentView.addSubview(button)
        isEdit ? didUpdateCategory(trackerCategory) : {}()
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 90),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addSceduleBtn(button: DetailButton) {
        contentView.addSubview(button)
        isEdit ? {didUpdateSchedule(tracker.scheduler)}() : {}()
        NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                                     button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                                     button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 150),
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
    
    func didUpdateSchedule(_ schedule: [DayOfWeek?]) {
        self.schedule = schedule
        let shortWeekDays = schedule.compactMap { $0?.shortWeekDay }
        if !schedule.isEmpty {
            sceduleBtn.titleEdgeInsets = UIEdgeInsets(top: -20, left: 5, bottom: 0, right: 0)
            sceduleBtn.setDetailText(shortWeekDays.joined(separator: ", "))
        } else {
            sceduleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            sceduleBtn.setDetailText("")
        }
    }
    
    func didUpdateCategory(_ category: String?) {
        self.trackerCategory = category
        if let category = category {
            categoryBtn.titleEdgeInsets = UIEdgeInsets(top: -20, left: 5, bottom: 0, right: 0)
            categoryBtn.setDetailText(category)
        } else {
            categoryBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
    }
    
}

extension NewTrackerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
                assertionFailure("Unable to dequeue EmojiCell")
                return UICollectionViewCell()
            }
            cell.configure(with: emojis[indexPath.item], isSelected: indexPath == selectedEmojiIndex)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else {
                assertionFailure("Unable to dequeue ColorCell")
                return UICollectionViewCell()
            }
            cell.configure(with: colors[indexPath.item], isSelected: indexPath == selectedColorIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.identifier,
                for: indexPath
              ) as? HeaderView else {
            fatalError("Unable to dequeue HeaderView")
        }
        header.configure(with: indexPath.section == 0 ? "Emoji" : "Цвет")
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let previousIndex = selectedEmojiIndex
            selectedEmojiIndex = indexPath
            self.emoji = emojis[indexPath.item]
            collectionView.reloadItems(at: [indexPath, previousIndex].compactMap { $0 })
        } else {
            let previousIndex = selectedColorIndex
            selectedColorIndex = indexPath
            self.color = colors[indexPath.item]
            collectionView.reloadItems(at: [indexPath, previousIndex].compactMap { $0 })
        }
    }
}
