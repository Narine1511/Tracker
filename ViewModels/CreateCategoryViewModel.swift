//
//  CreateCategoryViewModel.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 28.07.2026.
//
import Foundation

final class CreateCategoriesViewModel {
    private let trackerCategoryStore: TrackerCategoryStore
    
    private(set) var categoryName: String = ""
    private(set) var isCreateButtonEnabled: Bool = false
    
    var delegate: CreateCategoryControllerDelegate?
    
    var onNameChange: (() -> Void)?
    var createButton: (() -> Void)?
    var onCategoryCreated: ((TrackerCategory) -> Void)?
    
    
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
    }
    
    
    
    // MARK: - User Actions
    
    func updateName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        categoryName = trimmedName
        isCreateButtonEnabled = !trimmedName.isEmpty
        onNameChange?()
        createButton?()
    }
    
    
    func createCategory(name: String) {
        guard !categoryName.isEmpty else {
            return
        }
        let category = TrackerCategory(title: categoryName, trackers: [])
        trackerCategoryStore.save(category)
        onCategoryCreated?(category)
        
        delegate?.didCreateCategory(category)
        
        categoryName = ""
        isCreateButtonEnabled = false
        onNameChange?()
        createButton?()
        
    }
}

