//
//  Statistics.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 04.07.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private var statistics: [StatisticsItem] = []
    private let recordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StatisticsViewCell.self, forCellWithReuseIdentifier: "StatisticsViewCell")
        collectionView.isHidden = true
        return collectionView
    }()
    private func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let image = UIImage(named: "notFoundStatistics")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.textColor = .ypBlack
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupCollectionView()
        setupBindings()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadStatistics),
            name: NSNotification.Name("UpdateStatistics"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🟢 viewWillAppear вызван")

        loadStatistics()
    }
    
    private func setupBindings() {
        recordStore.onUpdate = { [weak self] in
            print("📢 RecordStore обновился!")
            self?.loadStatistics()
        }
        
        trackerStore.onUpdate = { [weak self] in
            print("📢 TrackerStore обновился!")
            self?.loadStatistics()
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            
            // Заглушка
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Коллекция
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
    }
    
    @objc  private func loadStatistics() {
        let allRecords = recordStore.fetchAll()
        print("📦 Записей в Core Data: \(allRecords.count)")
        let allTrackers = trackerStore.fetchAll()
        
        guard !allRecords.isEmpty else {
            print("❌ НЕТ ЗАПИСЕЙ!")
            statistics = []
            updateUI()
            return
        }
        
        let totalCompletions = allRecords.count
        statistics = [
            StatisticsItem(count: totalCompletions, title: "Трекеров завершено")]
        
        DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        
        // Выполнение уникальных трекеров
        /*  let uniqueTrackers = Set(allRecords.map { $0.trackerId}).count
        
        // Лучший период (месяц с наибольшим количеством выполнений)
        let calendar = Calendar.current
        var monthCounts: [String: Int] = [:]
        for record in allRecords {
            let monthKey = calendar.component(.month, from: record.date)
            let yearKey = calendar.component(.year, from: record.date)
            let key = "\(yearKey)-\(monthKey)"
            monthCounts[key, default: 0] += 1
        }
        let bestPeriod = monthCounts.values.max() ?? 0
        
        // Дней без пропусков (текущая непрерывная цепочка)
        let streak = calculateStreak(from: allRecords)
        
        statistics = [
            StatisticsItem(count: uniqueTrackers, title: "Лучший период"),
            StatisticsItem(count: totalCompletions, title: "Трекеров завершено"),
            StatisticsItem(count: bestPeriod, title: "Идеальные дни"),
            StatisticsItem(count: streak, title: "Среднее значение")
        ]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("🟣 Обновляем UI на главном потоке")
            self.updateUI()
        }*/
    }
    
   
    private func calculateStreak(from records: [TrackerRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let recordDates = Set(records.map { calendar.startOfDay(for: $0.date) })
        
        // Проверяем, есть ли запись сегодня
        var currentDate = today
        var streak = 0
        
        // Идем назад, пока есть записи
        while recordDates.contains(currentDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDay
        }
        
        return streak
    }
    private func updateUI() {
        let hasData = !statistics.isEmpty
        placeholderImageView.isHidden = hasData
        placeholderLabel.isHidden = hasData
        collectionView.isHidden = !hasData
        
        if hasData {
            collectionView.reloadData()
        }
    }
}
    
struct StatisticsItem {
    let count: Int
    let title: String
    }
extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "StatisticsViewCell",
                for: indexPath
            ) as? StatisticsViewCell else {
                return UICollectionViewCell()
            }
            
            let item = statistics[indexPath.item]
            cell.configure(count: item.count, title: item.title)
            return cell
        }
}
extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 1 - 12
        return CGSize(width: width, height: 90)
    }
}
