//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 11.07.2026.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [Weekday])
}

final class ScheduleViewController: UIViewController {
    private let dataSchedule = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        let label = UILabel()
        label.text = "Расписание"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.tintColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.widthAnchor.constraint(equalToConstant: 133)
        ])
        
        
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = 12
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
        
        let readyButton = UIButton(type: .system)
        readyButton.setTitle("Готово", for: .normal)
        readyButton.setTitleColor(.ypWhite, for: .normal)
        readyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        readyButton.titleLabel?.textAlignment = .center
        readyButton.layer.cornerRadius = 16
        readyButton.layer.borderWidth = 1
        readyButton.layer.borderColor = UIColor.ypBlack.cgColor
        readyButton.backgroundColor = .ypBlack
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
}
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSchedule[indexPath.row]
        cell.backgroundColor = .background
        cell.selectionStyle = .default
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = selectedDays[indexPath.row]
        toggleSwitch.tag = indexPath.row
        toggleSwitch.onTintColor = .ypBlue
        toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        cell.accessoryView = toggleSwitch
        
        return cell
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        selectedDays[sender.tag] = sender.isOn
    }
    
    @objc func readyButtonTapped() {
        let weekdays: [Weekday] = selectedDays.enumerated().compactMap{index, isSelected in
            guard isSelected else {return nil}
            return Weekday.allCases[index]
        }
        delegate?.didSelectDays(weekdays)
        dismiss(animated: true, completion:  nil)
    }
    
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedDays[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
       switch indexPath.row {
        case 0:
            let categoryVC = CategoryViewController()
            present(categoryVC, animated: true, completion: nil)
            
        case 1:
            let scheduleVC = ScheduleViewController()
            scheduleVC.title = dataSchedule[indexPath.row]
            present(scheduleVC, animated: true, completion: nil)
            
        default:
            break
        }*/
    }

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedDays[indexPath.row].toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
}

