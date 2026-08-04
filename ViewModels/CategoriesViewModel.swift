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
    var onPlaceholderStateChange: ((Bool) -> Void)?
    
    var shouldShowPlaceholder: Bool {
        return categories.isEmpty
    }
    
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesUpdate?()
            onPlaceholderStateChange?(shouldShowPlaceholder)
        }
    }
    
    private var selectedCategoryId: UUID?
    
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        loadCategories()
    }
    
    func loadCategories() {
        categories = trackerCategoryStore.fetchAll()
        onCategoriesUpdate?()
        onPlaceholderStateChange?(shouldShowPlaceholder)
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
        onCategorySelected?(category)
        onCategoriesUpdate?()
    }
}



