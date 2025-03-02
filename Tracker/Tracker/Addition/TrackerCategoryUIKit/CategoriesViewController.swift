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
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно обьеденить по смыслу"
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .black
        label.font = .systemFont(ofSize: .init(22), weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
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
        addEmpty(label: emptyLabel, image: emptyImageView)
        if viewModel.categories.count > 0 {
            emptyLabel.isHidden = true
            emptyImageView.isHidden = true
        }
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
        let maxHeight = view.frame.height - 300.0
        NSLayoutConstraint.activate([tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
                                     tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
                                     tableView.heightAnchor.constraint(equalToConstant: maxHeight),
                                     tableView.widthAnchor.constraint(equalToConstant: view.frame.width - 40)])
    }
    
    private func bindViewModel() {
        viewModel.categoriesUpdated = { [weak self] _ in
            guard let self else { return }
            if self.viewModel.categories.count > 0 {
                self.emptyLabel.isHidden = true
                self.emptyImageView.isHidden = true
            }
            self.tableView.reloadData()
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
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        onCategorySelected?(viewModel.categories[indexPath.row])
        dismiss(animated: true)
    }
}
