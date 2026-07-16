//
//  Trackers.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 04.07.2026.
//

/*import UIKit


final class TrackersViewController: UIViewController, UICollectionViewDelegate {
    private var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    /*var selectedDate: Date = Date()*/
    var trackers: [Tracker] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
        setupNavigationBar()
         setupCollectionView()
        /* loadMockData()*/
    }
    
    private func setupInitialData () {
       
        let tracker1 = Tracker(
            id: UUID(),
            label: "Пить воду",
            color: "#4A90D9",
            emoji: "✨",
            timetable: .init(days: [.monday]))
        
        let tracker2 = Tracker(
            id: UUID(),
            label: "Есть фрукты",
            color: "#4A90D9",
            emoji: "✨",
            timetable: .init(days: [.monday]))
        
        let category1 = TrackerCategory(
            title: "Здоровье",
            trackers: [tracker1, tracker2]
        )
        categories = [category1]
        trackers = categories.flatMap { $0.trackers }
        collectionView.reloadData()
    }
    
    private func setupNavigationBar() {
            title = "Трекеры"
            navigationController?.navigationBar.prefersLargeTitles = false
            
            let addButton = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addTrackerTapped)
            )
            navigationItem.leftBarButtonItem = addButton

        }
    private func setupCollectionView() {
            view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            collectionView.dataSource = self
            collectionView.delegate = self

        }
    @objc private func addTrackerTapped() {
        print("🟢 Кнопка + нажата!")
        let newTrackerVC = NewTrackerController()
        newTrackerVC.delegate = self
        let navController = UINavigationController(rootViewController: newTrackerVC)
        present(navController, animated: true)
    }
        
    
    func addTracker (tracker: Tracker, categoryTitle: String) {
        let updateCategories = categories.map{ category in
            if category.title == categoryTitle {
                let updateTrackers = category.trackers + [tracker]
                return TrackerCategory(
                    title: category.title,
                    trackers: updateTrackers)
            }
            return category
        }
        categories = updateCategories
        trackers = categories.flatMap{$0.trackers}
        collectionView.reloadData()
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
}
extension TrackersViewController: NewTrackerDelegate {
    func didCreateTracker(_ tracker: Tracker, category: String) {
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
            /*placeholder.isHidden = true*/
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count  // Количество трекеров в категории
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        cell.configure(tracker: tracker, isCompleted: false, count: 0)
        return cell
    }
}*/

