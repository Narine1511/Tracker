//
//  Untitled.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 11.07.2026.
//

import UIKit
protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(_ category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategorySelectionDelegate?
    private let viewModel = CategoriesViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 12
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorStyle = .singleLine
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.setTitleColor(.ypWhite, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addButton.titleLabel?.textAlignment = .center
        addButton.layer.cornerRadius = 16
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.ypBlack.cgColor
        addButton.backgroundColor = .ypBlack
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    private let placeholderImageView: UIImageView = {
        let image = UIImage(named: "star")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.textColor = .ypBlack
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            //Заголовок
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.widthAnchor.constraint(equalToConstant: 84),
            
            //вся таблица
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            
            // кнопка добавления категории
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Заглушка
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: "CategoryViewCell")
        
        setupUI()
        setupBindings()
        setupActions()
        viewModel.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCategories()
        tableView.reloadData()
        DispatchQueue.main.async {
            for cell in self.tableView.visibleCells {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onPlaceholderStateChange = {[weak self] shouldShow in
            self?.placeholderImageView.isHidden = !shouldShow
            self?.placeholderLabel.isHidden = !shouldShow
            self?.tableView.isHidden = shouldShow
        }
        viewModel.onCategorySelected = { [weak self] category in
            guard let self = self else { return }
            self.delegate?.didSelectCategory(category)
            self.dismiss(animated: true)
            /*self?.navigationController?.popViewController(animated: true)*/
        }
    }
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        //открыть экран создания категории
        let createVC = CreateCategoryController()
        createVC.delegate = self
        let navController = UINavigationController(rootViewController: createVC)
        present(navController, animated: true, completion: nil)
    }
}
extension CategoryViewController: CreateCategoryControllerDelegate {
    func didCreateCategory(_ category: TrackerCategory) {
        viewModel.loadCategories()
        
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let count = self.viewModel.countOfCategories()
            var indexPaths: [IndexPath] = []
            for row in 0..<count - 1 {
                indexPaths.append(IndexPath(row: row, section: 0))
            }
            if !indexPaths.isEmpty {
                self.tableView.reloadRows(at: indexPaths, with: .none)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath) as? CategoryViewCell else {
            return UITableViewCell()
        }
        
        
        let title = viewModel.categoryName(at: indexPath.row)
        let isSelected = viewModel.isCategorySelected(at: indexPath.row)
        let isLastRow = indexPath.row == viewModel.countOfCategories() - 1
        
        cell.configure(with: title, isSelected: isSelected, isLastRow: isLastRow)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectedCategory(at: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


