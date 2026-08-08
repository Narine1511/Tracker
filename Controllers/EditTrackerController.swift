//
//  EditTrackerController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 08.08.2026.
//
import UIKit

protocol EditTrackerDelegate: AnyObject {
    func didEditTracker(_ tracker: Tracker)
    func didCreateTracker(_ tracker: Tracker, category: String)
}

final class EditTrackerController: UIViewController {
    
    weak var delegate: EditTrackerDelegate?
    private let tracker: Tracker
    private let recordCount: Int
    
    private var trackerName: String
    private var selectedScheule: [Weekday]
    private var selectedEmoji: String
    private var selectedColor: String
    private var selectedCategory: TrackerCategory?
    
    private var trackerRecordCount: Int = 0
    
    private let data = ["Категория", "Расписание"]
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private let colors = ["ypCoral", "ypDarkBlue", "ypLavender", "ypLightBlue1", "ypLightBlue", "ypLightGreen", "ypLightOrange", "ypLightPink1", "ypLightPink", "ypLightRed", "ypLilac", "ypMagenta", "ypMint", "ypPeach", "ypPurple", "ypSoftPink", "ypTurquoise", "ypViolet"]
    
    // Заголовок
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Счётчик
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
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
        textField.backgroundColor = .ypGrayLight
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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
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
        saveButton.setTitle("Сохранить", for: .normal)
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
    
    // Эмодзи
    private let emojiesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 50, height: 50)
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        /*collectionview.backgroundColor = .ypLightGray*/
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(EmojiColorViewCell.self, forCellWithReuseIdentifier: "EmojiColorViewCell")
        collectionview.register(SectionHeaderEmojiesAndColorsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeaderEmojiesAndColorsView"
        )
        return collectionview
    }()
    
    init(tracker: Tracker, recordCount: Int) {
        self.tracker = tracker
        self.recordCount = recordCount
        print("🔵 recordCount в init: \(recordCount)")
        self.trackerName = tracker.label
        self.selectedEmoji = tracker.emoji
        self.selectedColor = tracker.color
        self.selectedScheule = tracker.timetable.days
        self.selectedCategory = tracker.category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        nameTextField.text = tracker.label
        trackerName = tracker.label
        
        view.addSubview(titleLabel)
        view.addSubview(countLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableViewTracker)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(emojiesView)
        
        tableViewTracker.dataSource = self
        tableViewTracker.delegate = self
        emojiesView.dataSource = self
        emojiesView.delegate = self
        
        
        let count = trackerRecordCount
        let text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: ""), count)
        countLabel.text = text
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.widthAnchor.constraint(equalToConstant: 218),
            
            //Счётчик
            
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              countLabel.heightAnchor.constraint(equalToConstant: 28),
            countLabel.widthAnchor.constraint(equalToConstant: 133),
            
            // Текстовое поле
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 38),
            
            // Таблица
            tableViewTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewTracker.heightAnchor.constraint(equalToConstant: 150),
            tableViewTracker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableViewTracker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            // Кнопка "Отменить"
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.topAnchor.constraint(equalTo: emojiesView.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            
            // Кнопка "Сохранить"
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            saveButton.topAnchor.constraint(equalTo: emojiesView.bottomAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 166),
            
            
            // Эмодзи
            
            emojiesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            emojiesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            emojiesView.topAnchor.constraint(equalTo: tableViewTracker.bottomAnchor, constant: 32),
            emojiesView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
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
        guard !selectedScheule.isEmpty else {return}
        
        let updatedTracker = Tracker(
            id: tracker.id,
            label: trackerName,
            color: selectedColor,
            emoji: selectedEmoji,
            timetable: TrackerSchedule(days: selectedScheule),
            category: selectedCategory
        )
        print("🔵 Трекер создан с категорией: \(tracker.category?.title ?? "nil")")
        delegate?.didEditTracker(updatedTracker)
        
        dismiss(animated: true)
    }
}

extension EditTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)*/
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row]
        cell.backgroundColor = .ypGrayLight
        cell.selectionStyle = .default
        
        cell.detailTextLabel?.font = .systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = .ypGray1
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = selectedCategory?.title ?? ""
        } else {
            let dayStrings = selectedScheule.map { $0.shortName }
            cell.detailTextLabel?.text = dayStrings.isEmpty ? "" : dayStrings.joined(separator: ", ")
        }
        
        let isLastRow = indexPath.row == 1
        
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
        
        return cell
    }
}

extension EditTrackerController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [Weekday]) {
        self.selectedScheule = days
        let indexPath = IndexPath(row: 1, section: 0)
        tableViewTracker.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension EditTrackerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("ℹ️ Категория: \(selectedCategory?.title ?? "Без категории")")
            
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

extension EditTrackerController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditTrackerController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojies.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EmojiColorViewCell",
            for: indexPath
        ) as? EmojiColorViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            let emoji = emojies[indexPath.item]
            cell.configureAsEmoji(emoji, isSelected: selectedEmoji == emoji)
        } else {
            let color = colors[indexPath.item]
            cell.configureAsColor(color, isSelected: selectedColor == color)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeaderEmojiesAndColorsView",
            for: indexPath
        ) as? SectionHeaderEmojiesAndColorsView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            header.configure(with: "Эмодзи")
        } else {
            header.configure(with: "Цвета")
        }
        return header
    }
}


extension EditTrackerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedEmoji = emojies[indexPath.item]
        } else {
            selectedColor = colors[indexPath.item]
        }
        collectionView.reloadData()
    }
}
extension EditTrackerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

