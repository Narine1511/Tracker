//
//  Trackers.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 04.07.2026.
//

import UIKit
final class TrackersViewController: UIViewController {
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var selectedDate: Date = Date()
    var trackers: [Tracker] = []
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
            )
            collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
    }
    
 /*   private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    */
    private func setupInitialData () {
        let tracker1 = Tracker(
            id: 1,
            label: "Пить воду",
            color: "#4A90D9",
            emoji: "💧",
            timetable: .init(days: [.monday]))
        
        let category1 = TrackerCategory(
            title: "Здоровье",
            trackers: [tracker1]
        )
        categories = [category1]
        trackers = categories.flatMap { $0.trackers }
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
    
    
    func toggleTrackerCompletion(trackerId: UInt, date: Date) {
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
/*extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrackersCollectionViewCell
        
        cell.titleLabel.text = trackers[indexPath.row].label
        return cell
    }
    
    extension TrackersViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            <#code#>
        }
    }
    
    extension TrackersViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            return CGSize(width: collectionView.bounds.width / 2, height: 50)
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 0
        }
    }
    
}*/
