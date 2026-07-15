//
//  ViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 19.06.2026.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Свойства
    private var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var trackers: [Tracker] = []
    private var currentDate: Date = Date()
    private var filteredCategories: [TrackerCategory] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
                collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    private func setupCollectionView() {

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: "SectionHeader")
    }
    
    // MARK: - UI Элементы
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let searchImageView = UIImageView(image: searchIcon)
        searchImageView.tintColor = .gray
        searchImageView.contentMode = .scaleAspectFit
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        searchImageView.frame = CGRect(x: 12, y: 5, width: 20, height: 20)
        leftViewContainer.addSubview(searchImageView)
        textField.leftView = leftViewContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let placeholderImageView: UIImageView = {
        let image = UIImage(named: "star")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupNavigationBar()
        setupUI()
        setupCollectionView()
        setupInitialData()
        /*updatePlaceholderVisibility()*/
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            // Поиск
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            // Заглушка
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Коллекция
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Настройка Navigation Bar
    private func setupNavigationBar() {
        let plusImage = UIImage(named: "plus")
        let addButton = UIBarButtonItem(
            image: plusImage,
            style: .plain,
            target: self,
            action: #selector(addTrackerTapped)
        )
        addButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = addButton
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 17
        components.month = 7
        components.year = 2026
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - Настройка данных
    private func setupInitialData() {
        let tracker1 = Tracker(
            id: UUID(),
            label: "Пить воду",
            color: "#4A90D9",
            emoji: "💧",
            timetable: .init(days: [.monday]))
        let tracker2 = Tracker(
            id: UUID(),
            label: "Есть фрукты",
            color: "#4A90D9",
            emoji: "💧",
            timetable: .init(days: [.friday]))
        
        let category1 = TrackerCategory(
            title: "Здоровье",
            trackers: [tracker1, tracker2]
        )
        categories = [category1]
        trackers = categories.flatMap { $0.trackers }
        /*collectionView.reloadData()*/
        updateTrackersForCurrentDate()
    }
    
    private func updatePlaceholderVisibility() {
        let hasTrackers = !filteredCategories.isEmpty && filteredCategories.contains { !$0.trackers.isEmpty }
        placeholderImageView.isHidden = hasTrackers
        placeholderLabel.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
    }
    
    // MARK: - Действия
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        
        currentDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let formattedDate = dateFormatter.string(from: currentDate)
        print("Выбранная дата: \(formattedDate)")
        updateTrackersForCurrentDate()
    }
    
    @objc private func addTrackerTapped() {
        print("🟢 Кнопка + нажата!")
        let newTrackerVC = NewTrackerController()
        newTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: newTrackerVC)
        present(navController, animated: true)
    }
    
    // MARK: - Методы работы с трекерами
    func addTracker(tracker: Tracker, categoryTitle: String) {
        let updateCategories = categories.map { category in
            if category.title == categoryTitle {
                let updateTrackers = category.trackers + [tracker]
                return TrackerCategory(
                    title: category.title,
                    trackers: updateTrackers
                )
            }
            return category
        }
        categories = updateCategories
        trackers = categories.flatMap { $0.trackers }
        /*collectionView.reloadData()
        updatePlaceholderVisibility()*/
        updateTrackersForCurrentDate()
    }
    
    func toggleTrackerCompletion(trackerId: UUID, date: Date) {
        if let index = completedTrackers.firstIndex(where: {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            var newCompleted = completedTrackers
            newCompleted.remove(at: index)
            completedTrackers = newCompleted
        } else {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
        }
    }
private func updateTrackersForCurrentDate() {
    let calendar = Calendar.current
    // Узнаём число дня недели из Date
    let weekdayNumber = Calendar.current.component(.weekday, from: currentDate)
    
    filteredCategories = categories.map { category in
        let filteredTrackers = category.trackers.filter {tracker in
            tracker.timetable.days.contains { $0.numberInCalendar == weekdayNumber}
            
        }
        return TrackerCategory(title: category.title, trackers: filteredTrackers)
    }.filter { !$0.trackers.isEmpty}

    trackers = filteredCategories.flatMap { $0.trackers }
    collectionView.reloadData()
    updatePlaceholderVisibility()
    
}
}
final class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold
        )
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

// MARK: - NewTrackerDelegate
extension ViewController: NewTrackerDelegate {
    func didCreateTracker(_ tracker: Tracker, category: String) {
        print("✅ ПОЛУЧИЛА ТРЕКЕР: \(tracker.label)")
        
        if let index = categories.firstIndex(where: { $0.title == category }) {
            let oldCategory = categories[index]
            let updateTrackers = oldCategory.trackers + [tracker]
            let newCategory = TrackerCategory(
                title: oldCategory.title,
                trackers: updateTrackers
            )
            categories[index] = newCategory
        } else {
            let newCategory = TrackerCategory(
                title: category,
                trackers: [tracker]
            )
            categories.append(newCategory)
        }
        
        /*collectionView.reloadData()
        updatePlaceholderVisibility()*/
        updateTrackersForCurrentDate()
        print("✅ Экран обновлён, трекеров: \(categories.flatMap { $0.trackers }.count)")
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return filteredCategories.count
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* return categories[section].trackers.count*/
        return filteredCategories[section].trackers.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        /* let tracker = categories[indexPath.section].trackers[indexPath.item]*/
        let tracker = trackers[indexPath.item]
        cell.configure(tracker: tracker, isCompleted: false, count: 0)
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeader",
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        let category = filteredCategories[indexPath.section]
        header.titleLabel.text = category.title
        header.isHidden = false
       /* if !trackers.isEmpty {
            header.titleLabel.text = "Трекеры"
        }*/
        return header
    }
    func collectionView(
           _ collectionView: UICollectionView,
           layout collectionViewLayout: UICollectionViewLayout,
           referenceSizeForHeaderInSection section: Int
       ) -> CGSize {
           // Проверяем, есть ли трекеры в этой секции
           /*
           if trackers.isEmpty {
                       return .zero
                   }*/

           return CGSize(width: collectionView.frame.width, height: 46)
       }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    // Методы делегата при необходимости
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 10
        let cellCount: CGFloat = 2
        let availableWidth = collectionView.frame.width - spacing * (cellCount - 1)
        let cellWidth = availableWidth / cellCount
        print("ширина \(collectionView.frame.width) и ширина ячейки \(cellWidth))")
                
                return CGSize(width: cellWidth, height: 148)
    }
    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 10
        }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}
    
