//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 28.07.2026.
//
import UIKit

protocol CreateCategoryControllerDelegate: AnyObject {
    func didCreateCategory(_ category: TrackerCategory)
}

final class CreateCategoryController: UIViewController {
    
    weak var delegate: CreateCategoryControllerDelegate?
    private let viewModel = CreateCategoriesViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.tintColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
       /* button.backgroundColor = .ypBlack*/
        button.backgroundColor = .ypGray1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupActions()
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        viewModel.delegate = self
        viewModel.createButton = { [weak self] in
            self?.createButton.isEnabled = self?.viewModel.isCreateButtonEnabled ?? false
            self?.createButton.backgroundColor = (self?.viewModel.isCreateButtonEnabled ?? false) ? .ypBlack : .ypGray1
            
        }
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(createButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            //Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: 14),
            
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldChanged() {
        viewModel.updateName(nameTextField.text ?? "")
    }
    
    @objc private func createTapped() {
        viewModel.createCategory(/*name: nameTextField.text ?? ""*/)
        print("Нажали на кнопку создания категории")
        // onCategoryCreated вызовет didCreateCategory в CategoryViewController
        dismiss(animated: true, completion: nil)
    }
}

extension CreateCategoryController: CreateCategoryControllerDelegate {
    func didCreateCategory(_ category: TrackerCategory) {
        delegate?.didCreateCategory(category)
    }
}
