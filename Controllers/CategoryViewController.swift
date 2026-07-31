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
    private var selectedCategory: TrackerCategory?
    private let viewModel = CategoriesViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.tintColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 12
        /*tableView.separatorColor = .ypGray1*/
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorStyle = .singleLine
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
        setupUI()
        setupBindings()
        setupActions()
        viewModel.loadCategories()
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        let hasCategories = viewModel.countOfCategories() > 0
        placeholderImageView.isHidden = hasCategories
        placeholderLabel.isHidden = hasCategories
        tableView.isHidden = !hasCategories
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.updatePlaceholderVisibility()
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
        viewModel.loadCategories()  // ← обновляем список
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countOfCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.categoryName(at: indexPath.row)
        cell.backgroundColor = .ypGrayLight
        cell.selectionStyle = .default
        
        let isLastRow = indexPath.row == viewModel.countOfCategories() - 1
        
        if isLastRow {
            cell.layer.cornerRadius = 12
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.masksToBounds = true
            cell.separatorInset = UIEdgeInsets(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: .greatestFiniteMagnitude)
        } else {
            cell.layer.cornerRadius = 0
            cell.layer.masksToBounds = false
        }
        
        /*if indexPath.row == viewModel.countOfCategories() - 1 {
            tableView.separatorStyle = .none
        }*/
            
            if viewModel.isCategorySelected(at: indexPath.row) {
                cell.accessoryType = .checkmark
                cell.tintColor = .ypBlue
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
    }

    // MARK: - UITableViewDelegate
    
    extension CategoryViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let category = viewModel.category(at: indexPath.row) else {
                return
            }
            viewModel.selectedCategory(at: indexPath.row)
            delegate?.didSelectCategory(category)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
    }


