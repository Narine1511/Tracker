//
//  ViewController.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 19.06.2026.
//

import UIKit
import AppMetricaCore
class ViewController: UIViewController {
    
    // MARK: - Свойства
    /*private* let*/ var trackerStore: TrackerStoreProtocol = TrackerStore()
    private let recordStore = TrackerRecordStore()
    private var containerView: UIView?
    private let defaultCategoryTitle = "Все трекеры"
    private var datePicker: UIDatePicker?
    /*private var categories: [TrackerCategory] = []*/
    var completedTrackers: [TrackerRecord] = []
    private var trackerRecordCount: [UUID: Int] = [:]
    var trackers: [Tracker] = []
    private var currentDate: Date = Date()
    private let analyticsService = AnalyticsService()
    
    private var filteredCategories: [TrackerCategory] = []
    private var allCategories: [TrackerCategory] = []
    private var currentFilter: String = "Все трекеры"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .ypWhite
        
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
        label.text = NSLocalizedString("trackers_label", comment: "")
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("search_placeholder", comment: "")
        let placeholderText = NSLocalizedString("search_placeholder", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypColorForPlaceholder
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: attributes
        )
        /*textField.textColor = .redLinearGradient*/
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let searchImageView = UIImageView(image: searchIcon)
        searchImageView.tintColor = .ypColorForPlaceholder
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
        label.text = NSLocalizedString("empty_message", comment: "")
        label.textColor = .ypBlack
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Заглушка после фильтрации
    private let placeholderFilterImageView: UIImageView = {
        let image = UIImage(named: "notFound")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderFilterLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("no_results", comment: "")
        label.textColor = .ypBlack
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка Фильтры
    private let filterButton: UIButton = {
        let filter = UIButton(type: .system)
        /*filter.setTitle("Фильтры", for: .normal)*/
        filter.setTitle(NSLocalizedString("filters_button", comment: ""), for: .normal)
        filter.setTitleColor(.ypWhiteButtonFilter, for: .normal)
        filter.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        filter.titleLabel?.textAlignment = .center
        filter.layer.cornerRadius = 16
        filter.backgroundColor = .ypBlue
        
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filter.isHidden = false
        return filter
    }()
    
    // MARK: - UI Методы
    
    
    private func updatePlaceholderVisibility() {
        let hasTrackers = !filteredCategories.isEmpty && filteredCategories.contains { !$0.trackers.isEmpty }
        if hasTrackers || currentFilter != "Все трекеры" {
            placeholderImageView.isHidden = true
            placeholderLabel.isHidden = true
            return
        }
        // ✅ НЕТ ТРЕКЕРОВ ВООБЩЕ
        placeholderImageView.isHidden = false
        placeholderLabel.isHidden = false
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderImageView.image = UIImage(named: "star")
        
        updateFilterButtonAppearance()
    }
    
    private func updatePlaceholderFilterVisibility() {
        let hasFilteredTrackers = !filteredCategories.isEmpty && filteredCategories.contains { !$0.trackers.isEmpty }
        
        let isFilterActive = currentFilter != "Все трекеры"
        let shouldShowFilterPlaceholder = isFilterActive && !hasFilteredTrackers
        
        
        if shouldShowFilterPlaceholder {
            placeholderFilterImageView.isHidden = false
            placeholderFilterLabel.isHidden = false
            placeholderFilterLabel.text = "Ничего не найдено"
            placeholderFilterImageView.image = UIImage(named: "notFound")
            
            // Скрываем обычную заглушку
            placeholderImageView.isHidden = true
            placeholderLabel.isHidden = true
        } else {
            placeholderFilterImageView.isHidden = true
            placeholderFilterLabel.isHidden = true
        }
    }
    
    private func setupInitialData() {
        let existingTrackers = trackerStore.fetchAll()
        guard existingTrackers.isEmpty else { return }
        
        let testTrackers = Tracker(
            id: UUID(),
            label: "Йога",
            color: "ypLightGreen",
            emoji: "🧘",
            timetable: TrackerSchedule(days: [.monday, .wednesday, .friday, .saturday, .sunday, .tuesday, .thursday]),
            category: nil
        )
        
        trackerStore.save(testTrackers)
        
    }
    
    private func updateDatePicker(for filter: String) {
        guard let datePicker = datePicker else { return }
        
        if filter == "Трекеры на сегодня" {
            datePicker.setDate(Date(), animated: true)
            datePicker.tintColor = .systemBlue
        } else {
            datePicker.tintColor = nil
        }
    }
    
    
    @objc private func filterButtonTapped() {
        
        analyticsService.sendEvent(event: "click", screen: "Main", item: "filter")
        
        let filterVC = FilterViewController()
        
        filterVC.onFilterSelected = {[weak self] filter in
            guard let self = self else { return }
            self.applyFilter(filter)
        }
        let navController = UINavigationController(rootViewController: filterVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func filterTrackers(_ categories: [TrackerCategory], byStatus status: String) -> [TrackerCategory] {
        let completedIds = Set(completedTrackers.map { $0.trackerId })
        
        return categories.map { category in
            let filtered = category.trackers.filter { tracker in
                switch status {
                case "Завершенные":
                    return completedIds.contains(tracker.id)
                case "Не завершенные":
                    return !completedIds.contains(tracker.id)
                default:
                    return true
                }
            }
            return TrackerCategory(title: category.title, trackers: filtered)
        }.filter { !$0.trackers.isEmpty }
    }
    
    private func updateFilterButtonAppearance() {
        let hasTrackers = !trackers.isEmpty
        let isFilterActive = currentFilter != "Все трекеры"
        
        // Скрываем кнопку, если нет трекеров
        guard hasTrackers else {
            filterButton.isHidden = true
            return
        }
        
        // Показываем кнопку, если есть трекеры
        filterButton.isHidden = false
        if isFilterActive {
            filterButton.backgroundColor = .ypPink
            filterButton.setTitleColor(.ypWhiteButtonFilter, for: .normal)
        } else {
            filterButton.backgroundColor = .ypBlue
            filterButton.setTitleColor(.ypWhiteButtonFilter, for: .normal)
        }
    }
    private func showFilterButtonIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            self?.updateFilterButtonAppearance()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        analyticsService.sendEvent(event: "open", screen: "Main")
        
        setupNavigationBar()
        setupUI()
        setupCollectionView()
        
        setupBindings()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.sendEvent(event: "close", screen: "Main")
    }
    
    private func setupBindings() {
        trackerStore.onUpdate = { [weak self] in
            self?.loadData()
        }
        recordStore.onUpdate = { [weak self] in
            self?.loadData()
        }
    }
    
    /*private*/ func loadData() {
        
        let allTrackers = trackerStore.fetchAll()
        let allRecords = recordStore.fetchAll()
        
        var newCount: [UUID: Int] = [:]
        for record in allRecords {
            newCount[record.trackerId, default: 0] += 1
        }
        trackerRecordCount = newCount
        completedTrackers = allRecords
        
        var groupCategories: [TrackerCategory] = []
        for tracker in allTrackers {
            if let category = tracker.category {
                if let index = groupCategories.firstIndex(where: {$0.id == category.id}) {
                    let old = groupCategories[index]
                    let updatedTrackers = old.trackers + [tracker]
                    groupCategories[index] = TrackerCategory(
                        id: old.id,
                        title: old.title,
                        trackers: updatedTrackers
                    )
                } else {
                    groupCategories.append(TrackerCategory(
                        id: category.id,
                        title: category.title,
                        trackers: [tracker]
                    ))
                }
            } else {
                if let index = groupCategories.firstIndex(where: {$0.title == "Без категории"}) {
                    let old = groupCategories[index]
                    let updatedTrackers = old.trackers + [tracker]
                    groupCategories[index] = TrackerCategory(
                        id: old.id,
                        title: old.title,
                        trackers: updatedTrackers
                    )
                } else {
                    groupCategories.append(TrackerCategory(
                        title: "Без категории",
                        trackers: [tracker]
                    ))
                }
            }
        }
        allCategories = groupCategories
        /*updateTrackersForCurrentDate()
         if currentFilter == "Завершенные" || currentFilter == "Не завершенные" {
         applyFilter(currentFilter)
         }*/
        applyFilter(currentFilter)
        showFilterButtonIfNeeded()
        setupInitialData()
    }
    
    /*private func applyFilter(_ filter: String) {
     currentFilter = filter
     updateDatePicker(for: filter)
     /*let allTrackers = trackerStore.fetchAll()
      let groupedCategories = groupTrackersByCategory(allTrackers)*/
     let groupedCategories = allCategories
     
     if filter == "Трекеры на сегодня" {
     currentDate = Date()
     datePicker?.setDate(currentDate, animated: true)
     datePicker?.tintColor = .ypBlue
     updateTrackersForCurrentDate()
     return
     } else {
     datePicker?.tintColor = nil
     }
     
     switch filter {
     case "Завершенные":
     filteredCategories = filterTrackers(groupedCategories, byStatus: "Завершенные")
     case "Не завершенные":
     filteredCategories = filterTrackers(groupedCategories, byStatus: "Не завершенные")
     default:
     filteredCategories = groupedCategories
     }
     collectionView.reloadData()
     updatePlaceholderVisibility()
     updatePlaceholderFilterVisibility()
     updateFilterButtonAppearance()
     }*/
    
    private func applyFilter(_ filter: String) {
        currentFilter = filter
        /* updateDatePicker(for: filter)*/
        print("🔍 applyFilter: \(filter)")
        print("📅 currentDate: \(currentDate)")
        // Получаем актуальные категории с учетом текущей даты
        let groupedCategories = getCategoriesForCurrentDate()
        
        // Применяем фильтр статуса
        switch filter {
        case "Завершенные":
            filteredCategories = filterTrackersByStatus(groupedCategories, status: .completed)
        case "Не завершенные":
            filteredCategories = filterTrackersByStatus(groupedCategories, status: .incomplete)
        default:
            // "Все трекеры" или "Трекеры на сегодня"
            filteredCategories = groupedCategories
        }
        trackers = filteredCategories.flatMap { $0.trackers }
        collectionView.reloadData()
        updatePlaceholderVisibility()
        updatePlaceholderFilterVisibility()
        updateFilterButtonAppearance()
    }
    
    
    private func getCategoriesForCurrentDate() -> [TrackerCategory] {
        let weekdayNumber = Calendar.current.component(.weekday, from: currentDate)
        
        return allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.timetable.days.contains { $0.numberInCalendar == weekdayNumber }
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
    }
    
    
    enum TrackerStatus {
        case completed
        case incomplete
    }
    
    private func filterTrackersByStatus(_ categories: [TrackerCategory], status: TrackerStatus) -> [TrackerCategory] {
        // Получаем ID завершенных трекеров на текущую дату
        let completedIds = Set(completedTrackers
            .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
            .map { $0.trackerId })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        print("""
            =================================
            📅 ТЕКУЩАЯ ДАТА: \(dateFormatter.string(from: currentDate))
            📊 Всего записей: \(completedTrackers.count)
            ✅ Завершенных на эту дату: \(completedIds.count)
            🆔 ID: \(completedIds)
            =================================
            """)
        
        return categories.map { category in
            let filtered = category.trackers.filter { tracker in
                switch status {
                case .completed:
                    return completedIds.contains(tracker.id)
                case .incomplete:
                    return !completedIds.contains(tracker.id)
                }
            }
            return TrackerCategory(title: category.title, trackers: filtered)
        }.filter { !$0.trackers.isEmpty }
    }
    
    private func groupTrackersByCategory(_ trackers: [Tracker]) -> [TrackerCategory] {
        return trackers.reduce(into: [TrackerCategory]()) { result, tracker in
            let categoryTitle = tracker.category?.title ?? "Без категории"
            if let index = result.firstIndex(where: { $0.title == categoryTitle }) {
                let updatedTrackers = result[index].trackers + [tracker]
                result[index] = TrackerCategory(title: categoryTitle, trackers: updatedTrackers)
            } else {
                result.append(TrackerCategory(title: categoryTitle, trackers: [tracker]))
            }
        }
    }
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        
        // Если был активен фильтр "Трекеры на сегодня", сбрасываем его
        if currentFilter == "Трекеры на сегодня" {
            currentFilter = "Все трекеры"
            datePicker?.tintColor = nil
        }
        
        // Переприменяем текущий фильтр с новой датой
        applyFilter(currentFilter)
    }
    
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(placeholderFilterImageView)
        view.addSubview(placeholderFilterLabel)
        view.addSubview(filterButton)
        
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
            
            // Заглушка для фильтрации
            
            placeholderFilterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderFilterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            placeholderFilterLabel.topAnchor.constraint(equalTo: placeholderFilterImageView.bottomAnchor, constant: 8),
            placeholderFilterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Коллекция
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Кнопка "Фильтры"
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
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
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        datePicker.preferredDatePickerStyle = .compact
        
        
        datePicker.locale = Locale(identifier: "ru_RU")
        /*datePicker.backgroundColor = .clear*/
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.datePicker = datePicker
        
        let containerView = UIView()
        self.containerView = containerView
        containerView.backgroundColor = .ypWhite
        containerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    

        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 17
        components.month = 7
        components.year = 2026
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    // MARK: - Настройка данных

    
    // MARK: - Действия
    
    @objc private func addTrackerTapped() {
        
        analyticsService.sendEvent(event: "click", screen: "Main", item: "add_track")
        
        let newTrackerVC = NewTrackerController()
        newTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: newTrackerVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    // MARK: - Методы работы с трекерами
    
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
    
    private func deleteTracker(_ tracker: Tracker, at indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Уверены что хотите удалить трекер?", preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.performDeleteTracker(tracker, at: indexPath)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func performDeleteTracker(_ tracker: Tracker, at indexPath: IndexPath) {
        
        do {
            try trackerStore.delete(tracker)
        } catch {
            print("❌ Ошибка удаления: \(error)")
            return
        }
        updateTrackersForCurrentDate()
        updatePlaceholderVisibility()
    }
    
    private func editTracker(_ tracker: Tracker) {
        let recordCount = trackerRecordCount[tracker.id] ?? 0
        print("🔵 recordCount в ViewController: \(recordCount)")
        let editVC = EditTrackerController(tracker: tracker, recordCount: recordCount)
        editVC.delegate = self
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    private func updateTrackersForCurrentDate() {
        let weekdayNumber = Calendar.current.component(.weekday, from: currentDate)
        
        // Фильтруем от allCategories, а не от categories
        filteredCategories = allCategories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.timetable.days.contains { $0.numberInCalendar == weekdayNumber }
            }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        trackers = filteredCategories.flatMap { $0.trackers }
        collectionView.reloadData()
        updatePlaceholderFilterVisibility()
        updatePlaceholderVisibility()
        updateFilterButtonAppearance()
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
}
// MARK: - NewTrackerDelegate
extension ViewController: NewTrackerDelegate {
    
    func didCreateTracker(_ tracker: Tracker, category: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.analyticsService.sendEvent(event: "create", screen: "Main", item: "tracker")
            print("✅ Получен трекер: \(tracker.label)")
            print("✅ Категория: \(category)")
            trackerStore.save(tracker)
            loadData()
            
        }
    }
}
    
    // MARK: - UICollectionViewDataSource
    extension ViewController: UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return filteredCategories.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredCategories[section].trackers.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell",
                for: indexPath) as? TrackersCollectionViewCell else {
                return UICollectionViewCell()
            }
            let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
            
            
            let allRecords = recordStore.fetchAll()
            /*let count = allRecords.filter { $0.trackerId == tracker.id }.count*/
            
            let context = AppDelegate.shared.context
            let request = TrackerRecordCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "trackerId == %@", tracker.id as CVarArg)
            let count = (try? context.count(for: request)) ?? 0
            
            let isCompleted = recordStore.isRecorded(
                trackerId: tracker.id,
                date: currentDate)
            
            cell.configure(tracker: tracker, isCompleted: isCompleted, count: count)
            cell.delegate = self
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
            return header
        }
        
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            referenceSizeForHeaderInSection section: Int
        ) -> CGSize {
            
            return CGSize(width: collectionView.frame.width, height: 46)
        }
    }

    // MARK: - UICollectionViewDelegate
    extension ViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
            guard let indexPath = indexPaths.first else { return nil}
            guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
                return nil
            }
            
            let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: {
                let previewVC = UIViewController()
                previewVC.view.backgroundColor = .clear
                
                let colorViewCopy = UIView()
                colorViewCopy.backgroundColor = cell.colorView.backgroundColor
                colorViewCopy.layer.cornerRadius = cell.colorView.layer.cornerRadius
                colorViewCopy.frame = CGRect(x: 0, y: 0, width: cell.colorView.bounds.width, height: cell.colorView.bounds.height)
                previewVC.view.addSubview(colorViewCopy)
                colorViewCopy.translatesAutoresizingMaskIntoConstraints = false
                
                let textPreview = UILabel()
                textPreview.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                textPreview.textColor = .ypWhite
                textPreview.text = cell.textLabel.text
                colorViewCopy.addSubview(textPreview)
                textPreview.translatesAutoresizingMaskIntoConstraints = false
                
                let emojiPreviw = UILabel()
                emojiPreviw.font = .systemFont(ofSize: 12)
                emojiPreviw.text = cell.emoji.text
                emojiPreviw.textAlignment = .center
                emojiPreviw.contentMode = .center
                emojiPreviw.backgroundColor = .ypWhite30
                emojiPreviw.layer.cornerRadius = 12
                emojiPreviw.clipsToBounds = true
                colorViewCopy.addSubview(emojiPreviw)
                emojiPreviw.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    colorViewCopy.centerXAnchor.constraint(equalTo: previewVC.view.centerXAnchor),
                    colorViewCopy.centerYAnchor.constraint(equalTo: previewVC.view.centerYAnchor),
                    colorViewCopy.widthAnchor.constraint(equalToConstant: cell.colorView.bounds.width),
                    colorViewCopy.heightAnchor.constraint(equalToConstant: cell.colorView.bounds.height),
                    // Текст
                    textPreview.leadingAnchor.constraint(equalTo: colorViewCopy.leadingAnchor, constant: 12),
                    textPreview.trailingAnchor.constraint(equalTo: colorViewCopy.trailingAnchor, constant: -12),
                    textPreview.bottomAnchor.constraint(equalTo: colorViewCopy.bottomAnchor, constant: -12),
                    
                    // Эмодзи
                    emojiPreviw.leadingAnchor.constraint(equalTo: colorViewCopy.leadingAnchor, constant: 12),
                    emojiPreviw.topAnchor.constraint(equalTo: colorViewCopy.topAnchor, constant: 12),
                    emojiPreviw.heightAnchor.constraint(equalToConstant: 24),
                    emojiPreviw.widthAnchor.constraint(equalToConstant: 24),
                ])
                previewVC.preferredContentSize = cell.colorView.bounds.size
                return previewVC
            }) { _ in
                
                let editAction = UIAction(title: "Редактировать", image: nil) { [weak self] _ in
                    
                    self?.analyticsService.sendEvent(event: "click", screen: "Main", item: "edit")
                    
                    guard let self = self else {return}
                    self.editTracker(tracker)
                }
                
                let deleteAction = UIAction(title: "Удалить", image: nil, attributes: .destructive) {[weak self] _ in
                    
                    self?.analyticsService.sendEvent(event: "click", screen: "Main", item: "delete")
                    
                    print("Удалить")
                    self?.deleteTracker(tracker, at: indexPath)
                }
                return UIMenu(title: "", children: [editAction, deleteAction])
            }
        }
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


// MARK: - UICollectionViewDelegate

extension ViewController: TrackersCollectionViewCellDelegate {
    func didTapCompleteButton(for trackerId: UUID, isCompleted: Bool) -> Bool {
        
        analyticsService.sendEvent(event: "click", screen: "Main", item: "track")
        
        print("didTapCompleteButton ВЫЗВАН 🟢🟢🟢")
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: currentDate)
        print("   - selectedDate: \(selectedDate)")
        print("   - today: \(today)")
        print("   - selectedDate > today: \(selectedDate > today)")
        
        if selectedDate > today {
            print("❌ БУДУЩАЯ ДАТА! ВОЗВРАЩАЕМ false")
            return false
            
        }
        print("✅ ДАТА НОРМАЛЬНАЯ, ПРОДОЛЖАЕМ")
        if isCompleted {
            // Снимаем отметку
            print("🗑️ isCompleted = true → УДАЛЯЕМ")
            let record = TrackerRecord(
                trackerId: trackerId,
                date: selectedDate)
            recordStore.delete(record)
            

        } else {
            // Отмечаем выполнение
            print("💾 isCompleted = false → СОХРАНЯЕМ")
            let record = TrackerRecord(
                trackerId: trackerId,
                date: selectedDate)
            recordStore.save(record)
            
        }
        
        let savedFilter = currentFilter
                let savedDate = currentDate
        
        NotificationCenter.default.post(name: NSNotification.Name("UpdateStatistics"), object: nil)
        
        
        DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
            
            self.completedTrackers = self.recordStore.fetchAll()
            self.applyFilter(self.currentFilter)
                    }
        return true
    }
    
}

// MARK: - EditTrackerDelegate

extension ViewController: EditTrackerDelegate {
    func didEditTracker(_ tracker: Tracker) {
        do {
            try trackerStore.update(tracker)
            loadData()
        } catch {
            print("Ошибка: \(error)")
        }
    }
}

