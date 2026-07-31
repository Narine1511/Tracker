//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 26.07.2026.
//
import Foundation

final class CategoriesViewModel {
    private let trackerCategoryStore: TrackerCategoryStore
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    var onCategoriesUpdate: (() -> Void)?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesUpdate?()
        }
    }
    private var selectedCategoryId: UUID?
    
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        loadCategories()
    }
    
    func loadCategories() {
        categories = trackerCategoryStore.fetchAll()
    }
    func countOfCategories() -> Int {
        return categories.count
    }
    func category(at index: Int) -> TrackerCategory? {
        guard index < categories.count else {return nil}
        return categories[index]
    }
    func categoryName(at index: Int) -> String {
        guard let category = category(at: index) else {return ""}
        return category.title
    }
    func isCategorySelected(at index: Int) -> Bool {
        guard let category = category(at: index) else {return false}
        return category.id == selectedCategoryId
    }
    
    
// MARK: - User Actions
    func selectedCategory(at index: Int) {
        guard let category = category(at: index) else {return}
        selectedCategoryId = category.id
        onCategoriesUpdate?()
    }
    
   /* func createCategory(name: String) {
        guard !name.isEmpty else {
            return
        }
        let category = TrackerCategory(
            id: UUID(),
            title: name,
            trackers: [])
        trackerCategoryStore.save(category)
        loadCategories()
        
    }
    
    func deleteCategory(at index: Int) {
        guard let category = category(at: index) else {return}
        trackerCategoryStore.delete(category)
        loadCategories()
        
    }*/
    
  /*  private func setupBindings() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChange),
            name: .categoryDataChange,
            object: nil)
    }
    @objc private func handleDataChange() {
        loadCategories()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }*/
    
}

