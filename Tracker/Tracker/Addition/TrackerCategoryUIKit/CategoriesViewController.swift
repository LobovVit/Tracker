//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Vitaly Lobov on 20.02.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private let viewModel = CategoryViewModel()
    
    var onCategorySelected: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
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
    
    private func setupUI() {
        view.backgroundColor = .white
        addLabel(label: label)
        addAdditionBtn(button: additionBtn)
        addTableView(tableView: tableView)
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
    
    private func bindViewModel() {
        viewModel.categoriesUpdated = { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func didTapAddition() {
        let vc = CategoryViewController(viewModel: viewModel)
        present(vc, animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        onCategorySelected?(viewModel.categories[indexPath.row])
        dismiss(animated: true)
    }
}
