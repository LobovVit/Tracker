//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 05.01.2025.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func didUpdateCategory(_ category: String?)
}

final class CategoriesViewController: UIViewController {
    
    private var items: [String] = []
    private var selectedIndex: Int? = nil
    private let trackerCategoryStore = TrackerCategoryStore()
    
    weak var delegate: CategoriesViewControllerDelegate?
    
    private var categoryName: String?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Катеория"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить катеорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15;
        button.addTarget(self, action: #selector(didTapAddition), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "additionBtn"
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.ypGray.cgColor
        tableView.rowHeight = 60
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addLabel(label: label)
        addAdditionBtn(button: additionBtn)
        addTableView(tableView: tableView)
    }
    
    init(categories: [String], category: String?) {
        //items = categories
        items = trackerCategoryStore.trackerCategories.map { $0.name }.reversed()
        if let category {
            selectedIndex = items.firstIndex(where: { $0 == category })
        } else {
            selectedIndex = nil
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapAddition() {
        let vc = CategoryViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
        tableView.reloadData()
    }
    
    private func addLabel(label: UILabel) {
        view.addSubview(label)
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)])
    }
    
    private func addAdditionBtn(button: UIButton) {
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                                     button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     button.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    private func addTableView(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        //let maxHeight = view.frame.height - 300.0 < CGFloat(items.count) * 60.0 ? view.frame.height - 300.0 : //CGFloat(items.count) * 60.0
        let maxHeight = view.frame.height - 300.0
        NSLayoutConstraint.activate([tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
                                     tableView.heightAnchor.constraint(equalToConstant: maxHeight),
                                     tableView.widthAnchor.constraint(equalToConstant: view.frame.width - 40)])
    }
    
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if cell.interactions.isEmpty {
            let interaction = UIContextMenuInteraction(delegate: self)
            cell.addInteraction(interaction)
        }
        cell.textLabel?.text = items[indexPath.row]
        cell.backgroundColor = .ypGray
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        categoryName = items[indexPath.row]
        delegate?.didUpdateCategory(categoryName)
        dismiss(animated: true, completion: nil)
    }
}


extension CategoriesViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = interaction.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            self.makeContextMenu(forRowAt: indexPath)
        }
    }
    
    private func getTextFromCell(at indexPath: IndexPath) -> String? {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        return cell.textLabel?.text
    }
    
    func makeContextMenu(forRowAt indexPath: IndexPath) -> UIMenu {
        let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) {  [weak self ] _ in
            guard let self else { return }
            print("Edit row \(indexPath.row)")
            var categoryName: String?
            if let text = getTextFromCell(at: indexPath) {
                categoryName = text
            }
            let vc = CategoryViewController(categoryName: categoryName)
            vc.modalPresentationStyle = .automatic
            self.present(vc, animated: true)
        }
        
        let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            print("Delete row \(indexPath.row)")
        }
        
        return UIMenu(title: "Options", children: [editAction, deleteAction])
    }
    
    func loadSelectedCategory(from categoryName: String?) {
        self.categoryName = categoryName
    }
}

extension CategoriesViewController: CategoryViewControllerDelegate {
    func didSaveCategory(_ category: String) {
        dismiss(animated: true)
        do {
            try trackerCategoryStore.updateTrackerCategory(TrackerCategory(name: category, trackers: []))
        } catch {
            print("ERR trackerCategoryStore.addNewTrackerCategory(updatedCategory): \(error)")
        }
        items = trackerCategoryStore.trackerCategories.map { $0.name }.reversed()
        selectedIndex = items.firstIndex(where: { $0 == category })
        tableView.reloadData()
    }
}

extension CategoriesViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        items = trackerCategoryStore.trackerCategories.map { $0.name }.reversed()
        tableView.reloadData()
    }
}
