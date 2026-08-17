//
//  FilterViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 08.08.2026.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(_ days: [Weekday])
}

final class FilterViewController: UIViewController {
    private enum UserDefaultsKeys {
            static let selectedFilter = "selectedFilter"
        }
    
    private let dataFilters = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    private var selectedFilterIndex: Int = 0
    var onFilterSelected: ((String) -> Void)?
    
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        loadSavedFilter()
        
        let label = UILabel()
        label.text = "Фильтры"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.tintColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 12
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    private func loadSavedFilter() {
            let savedFilter = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedFilter) ?? "Все трекеры"
            selectedFilterIndex = dataFilters.firstIndex(of: savedFilter) ?? 0
        }
    
    private func saveFilter(_ filter: String) {
            UserDefaults.standard.set(filter, forKey: UserDefaultsKeys.selectedFilter)
        }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataFilters[indexPath.row]
        cell.backgroundColor = .background
        cell.selectionStyle = .default
        
        if indexPath.row == selectedFilterIndex {
            cell.accessoryType = .checkmark
            cell.tintColor = .ypBlue
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        selectedFilterIndex = indexPath.row
        let selectedFilter = dataFilters[selectedFilterIndex]
        saveFilter(selectedFilter)
        tableView.reloadData()
        
        onFilterSelected?(selectedFilter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.dismiss(animated: true)
                }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Убираем сепаратор у последней ячейки
            if indexPath.row == dataFilters.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
}
