//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 24.12.2024.
//

import UIKit

private enum FilterType {
    case all
    case today
    case completed
    case uncompleted
}

final class TrackersViewController: UIViewController {
    
    private var alertPresenter: AlertPresenting?
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    private var trackers: [Tracker] = []
    private var currentDate: Date = Date()
    private var currentFilter: FilterType = .all
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var analyticsService = AnalyticsService()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Trackers".localized
        label.textColor = .textColor
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
        textField.placeholder = "Search".localized
        textField.layer.cornerRadius = 15;
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0.5
        textField.backgroundImage = UIImage()
        textField.searchTextField.backgroundColor = .searchBarColor
        textField.backgroundColor = .searchBarColor
        textField.layer.borderColor = UIColor.searchBarColor.cgColor
        textField.searchTextField.font = .systemFont(ofSize: .init(17), weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "What will we track?".localized
        label.textColor = .textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorImage: UIImageView = {
        let errorImage = UIImageView()
        errorImage.image = UIImage(named: "Error")
        errorImage.translatesAutoresizingMaskIntoConstraints = false
        return errorImage
    }()
    
    private lazy var errorLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Nothing found".localized
        descriptionLabel.textColor = .textColor
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filters".localized, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService.report(event: "open", params: ["screen": "Main"])
        alertPresenter = AlertPresenter(viewController: self)
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
        addLabel(label: label)
        addDatePicker(datePicker: datePicker)
        addPlusBtn(button: plusBtn)
        addTextField(textField: textField)
        addCollectionView(collection: collectionView)
        addErr(label: errorLabel, image: errorImage)
        addEmpty(label: emptyLabel, image: emptyImageView)
        addFilterButton()
        updateVisible()
        updateTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.report(event: "close", params: ["screen": "Main"])
    }
    
    private func addFilterButton() {
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            filterButton.heightAnchor.constraint(equalToConstant: 44),
            filterButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc private func didTapFilterButton() {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
        let alert = UIAlertController(title: "Filters".localized, message: nil, preferredStyle: .actionSheet)
        
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        let attributedTitle = NSAttributedString(string: "Filters".localized, attributes: titleAttributes)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        let allAction = UIAlertAction(title: "All trackers".localized, style: .default) { _ in
            self.applyFilter(.all)
        }
        let todayAction = UIAlertAction(title: "Trackers for today".localized, style: .default) { _ in
            self.datePicker.date = Date()
            self.applyFilter(.today)
        }
        let completedAction = UIAlertAction(title: "Completed".localized, style: .default) { _ in
            self.applyFilter(.completed)
        }
        let uncompletedAction = UIAlertAction(title: "Incomplete".localized, style: .default) { _ in
            self.applyFilter(.uncompleted)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        let checkmarkImage = UIImage(systemName: "checkmark")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        
        switch currentFilter {
        case .all:
            allAction.setValue(checkmarkImage, forKey: "image")
        case .today:
            todayAction.setValue(checkmarkImage, forKey: "image")
        case .completed:
            completedAction.setValue(checkmarkImage, forKey: "image")
        case .uncompleted:
            uncompletedAction.setValue(checkmarkImage, forKey: "image")
        }
        
        alert.addAction(allAction)
        alert.addAction(todayAction)
        alert.addAction(completedAction)
        alert.addAction(uncompletedAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func applyFilter(_ filter: FilterType) {
        currentFilter = filter
        updateVisible()
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: message,
                message: message,
                buttonText: "OK".localized,
                completion: {  }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
    
    private func addErr(label: UILabel,image: UIImageView) {
        view.addSubview(label)
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    private func addEmpty(label: UILabel, image: UIImageView) {
        view.addSubview(label)
        view.addSubview(image)
        NSLayoutConstraint.activate([image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
                                     label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
                                    ])
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateVisible()
    }
    
    private func updateVisible() {
        let calendar = Calendar.current
        let selectedDayIndex = calendar.component(.weekday, from: currentDate)
        guard let selectedWeekDay = DayOfWeek.getDayEnum(number: selectedDayIndex) else { return }
        
        var pinnedTrackers: [Tracker] = []
        var otherCategories: [TrackerCategory] = []
        
        for category in categories {
            let trackers = category.trackers.filter { tracker in
                let isTrackerForToday = tracker.scheduler.isEmpty || tracker.scheduler.contains(selectedWeekDay)
                let isCompleted = isTrackerCompletedToday(id: tracker.id)
                switch currentFilter {
                case .all:
                    return isTrackerForToday
                case .today:
                    return isTrackerForToday
                case .completed:
                    return isTrackerForToday && isCompleted
                case .uncompleted:
                    return isTrackerForToday && !isCompleted
                }
            }
            
            if trackers.isEmpty { continue }
            
            let pinned = trackers.filter { $0.isPinned }
            let nonPinned = trackers.filter { !$0.isPinned }
            
            pinnedTrackers.append(contentsOf: pinned)
            
            if !nonPinned.isEmpty {
                otherCategories.append(TrackerCategory(name: category.name, trackers: nonPinned))
            }
        }
        
        filteredCategories = []
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(name: "Pinned".localized, trackers: pinnedTrackers)
            filteredCategories.append(pinnedCategory)
        }
        
        filteredCategories.append(contentsOf: otherCategories)
        
        showErrorImage(filteredCategories.isEmpty, trackerStore.trackersCount() == 0)
        collectionView.reloadData()
    }
    
    private func showErrorImage(_ showError: Bool, _ showEmty: Bool) {
        collectionView.isHidden = showError || showEmty
        errorImage.isHidden = !showError || showEmty
        errorLabel.isHidden = !showError || showEmty
        emptyLabel.isHidden = !showEmty
        emptyImageView.isHidden = !showEmty
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
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
        let vc = AdditionViewController()
        vc.saveTrackerDelegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
}

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            assertionFailure("Unable to dequeue TrackerCell")
            return UICollectionViewCell()
        }
        let item = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        let completedDay = (try? trackerRecordStore.completedDays(for: item.id).count) ?? 0
        let isCompletedToday = isTrackerCompletedToday(id: item.id)
        cell.delegate = self
        cell.configure(with: item, completedDay: completedDay, isCompletedToday: isCompletedToday, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            fatalError("Unable to dequeue HeaderView")
        }
        header.configure(with: filteredCategories[indexPath.section].name)
        return header
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        do {
            let completedDates = try trackerRecordStore.completedDays(for: id)
            return completedDates.contains { Calendar.current.isDate($0, inSameDayAs: datePicker.date) }
        } catch {
            return false
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        do {
            return try trackerRecordStore.fetchRecord(id: id, date: datePicker.date) != nil
        } catch {
            print("ERR: trackerRecordStore.fetchRecord: \(error)")
            return false
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}


extension TrackersViewController: SaveTrackerDelegate {
    func didSaveTracker(_ tracker: Tracker, _ category: String) {
        dismiss(animated: true)
        trackerStore.updateTracker(tracker, newCategory: category)
        categories = trackerCategoryStore.trackerCategories
        updateVisible()
        collectionView.reloadData()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func getCategorys() -> [String] {
        return categories.map { $0.name }
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        let calendar = Calendar.current
        let todayDate = Date()
        let truncDate = calendar.startOfDay(for: todayDate)
        let endOfDay = calendar.date(byAdding: DateComponents(hour: 23, minute: 59, second: 59), to: truncDate) ?? truncDate
        guard datePicker.date < endOfDay else {
            showAlert(message: "Cannot mark a tracker for a future date".localized + " \(formatter.string(from: truncDate))")
            return
        }
        
        do {
            try trackerRecordStore.updateRecord(id: id, date: datePicker.date)
        } catch {
            print("ERR: trackerRecordStore.updateRecord(id: id, date: datePicker.date): \(error)")
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
        do {
            try trackerRecordStore.deleteRecord(id: id, date: datePicker.date)
        } catch {
            print("ERR: trackerRecordStore.deleteRecord(id: id, date: datePicker.date): \(error)")
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let isPinned = tracker.isPinned
        let category = filteredCategories[indexPath.section]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let pinAction = UIAction(title: isPinned ? "Unpin".localized : "Pin".localized, image: UIImage(systemName: "pin")) { [weak self] _ in
                self?.togglePin(for: tracker, at: indexPath)
            }
            
            let editAction = UIAction(title: "Edit".localized, image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.editTracker(for: tracker, category: category, at: indexPath)
            }
            
            let deleteAction = UIAction(title: "Delete".localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteTracker(tracker, at: indexPath)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
    
    private func togglePin(for tracker: Tracker, at indexPath: IndexPath) {
        trackerStore.changePinnedTracker(tracker)
        categories = trackerCategoryStore.trackerCategories
        updateVisible()
        collectionView.reloadData()
    }
    
    private func editTracker(for tracker: Tracker, category: TrackerCategory , at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
        let vc = NewTrackerViewController(type: .edit, item: tracker, category: category.name)
        vc.saveTrackerDelegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true) { [weak self] in
            DispatchQueue.main.async {
                self?.updateVisible()
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func deleteTracker(_ tracker: Tracker, at indexPath: IndexPath) {
        analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
        let alert = UIAlertController(title: "Are you sure you want to delete the tracker?".localized, message: nil, preferredStyle: .actionSheet)
        let dellAction = UIAlertAction(title: "Delete".localized, style: .destructive) { _ in
            self.trackerStore.deleteTracker(tracker)
            self.updateVisible()
            self.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(dellAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        categories = trackerCategoryStore.trackerCategories
        updateVisible()
        collectionView.reloadData()
    }
}

extension TrackersViewController{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTheme()
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = .backgroundColor
        label.textColor = .textColor
        errorLabel.textColor = .textColor
        textField.searchTextField.backgroundColor = .searchBarColor
        textField.backgroundColor = .searchBarColor
        textField.layer.borderColor = UIColor.searchBarColor.cgColor
        collectionView.backgroundColor = .backgroundColor
    }
}
