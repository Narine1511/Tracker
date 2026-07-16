//
//  NewTrackerController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 10.07.2026.
//

import UIKit
import Foundation
protocol NewTrackerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, category: String)
}

final class NewTrackerController: UIViewController {
    
    weak var delegate: NewTrackerDelegate?
    
   
    private var trackerName: String = ""
    private let categoryName = "Важное"
    private let schedule: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    private let data = ["Категория", "Расписание"]
    private let tableView = UITableView()
    private var selectedScheule: [Weekday] = []
    
    // Заголовок
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Текстовое поле
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .background
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    // Таблица
    private let tableViewTracker: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = 12
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // Кнопка "Отменить"
    private let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.backgroundColor = .ypWhite
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    //Кнопка "Сохранить"
    private let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.layer.cornerRadius = 12
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.ypGray1.cgColor
        saveButton.backgroundColor = .ypGray1
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        nameTextField.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableViewTracker)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.widthAnchor.constraint(equalToConstant: 133),
            
            // Текстовое поле
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            
            // Таблица
            tableViewTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewTracker.heightAnchor.constraint(equalToConstant: 150),
            tableViewTracker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableViewTracker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            // Кнопка "Отменить"
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            
            // Кнопка "Сохранить"
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 166)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        tableViewTracker.dataSource = self
        tableViewTracker.delegate = self

    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldChanged(_ textField: UITextField) {
        // Сохраняем введенный текст в переменную
        trackerName = textField.text ?? ""
        // Если текст не пустой - кнопка активна (черная)
        // Если текст пустой - кнопка неактивна (серая)
        saveButton.isEnabled = !trackerName.isEmpty
        saveButton.backgroundColor = saveButton.isEnabled ? .ypBlack : .ypGray1
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        // Логика сохранения
        guard !trackerName.isEmpty else {return}
        guard !selectedScheule.isEmpty else {
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            label: trackerName,
            color: "ypBlue",
            emoji: "🧚‍♀️",
            timetable: TrackerSchedule(days: selectedScheule)
        )
        print("🔵 Проверка делегата: \(delegate != nil ? "ЕСТЬ ✅" : "НЕТ ❌")")
        delegate?.didCreateTracker(tracker, category: "Важное")
        
        dismiss(animated: true)
    }
}
        
extension NewTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.backgroundColor = .background
        cell.selectionStyle = .default
        return cell
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let categoryVC = CategoryViewController()
            present(categoryVC, animated: true, completion: nil)
            
        case 1:
            let scheduleVC = ScheduleViewController()
            scheduleVC.title = data[indexPath.row]
            scheduleVC.delegate = self
            present(scheduleVC, animated: true, completion: nil)
            
        default:
            break
        }
    }*/
}

extension NewTrackerController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [Weekday]) {
        self.selectedScheule = days
        let indexPath = IndexPath(row: 1, section: 0)
                tableViewTracker.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension NewTrackerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
              print("Индекс: \(indexPath.row)")
              print("Текст: \(data[indexPath.row])")
              print("tableViewTracker: \(tableViewTracker)")
        tableView.deselectRow(at: indexPath, animated: true)
            
            switch indexPath.row {
            case 0:
                let categoryVC = CategoryViewController()
                present(categoryVC, animated: true, completion: nil)
                
            case 1:
                let scheduleVC = ScheduleViewController()
                scheduleVC.title = data[indexPath.row]
                scheduleVC.delegate = self
                present(scheduleVC, animated: true, completion: nil)
                
            default:
                break
            }
        
    }
}

extension NewTrackerController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

