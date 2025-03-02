//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Vitaly Lobov on 20.02.2025.
//

import UIKit

final class CategoryViewModel {
    var categories: [String] = [] {
        didSet { categoriesUpdated?(categories) }
    }
    var selectedCategory: String? {
        didSet { selectedCategoryUpdated?(selectedCategory) }
    }
    var newCategoryName: String? {
        didSet { newCategoryNameUpdated?(newCategoryName) }
    }
    
    var categoriesUpdated: (([String]) -> Void)?
    var selectedCategoryUpdated: ((String?) -> Void)?
    var newCategoryNameUpdated: ((String?) -> Void)?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    init() {
        loadCategories()
    }
    
    func loadCategories() {
        categories = trackerCategoryStore.trackerCategories.map { $0.name }.reversed()
    }
    
    func selectCategory(at index: Int) {
        selectedCategory = categories[index]
    }
    
    func addCategory() {
        guard let newCategoryName, !newCategoryName.isEmpty else { return }
        do {
            try trackerCategoryStore.updateTrackerCategory(TrackerCategory(name: newCategoryName, trackers: []))
            loadCategories()
        } catch {
            print("ERR: updating category: \(error)")
        }
    }
}
