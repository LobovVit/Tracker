//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Vitaly Lobov on 17.02.2025.
//

import Foundation
import CoreData

class TrackerCategoryViewModel: ObservableObject {
    @Published var categories: [TrackerCategoryCoreData] = []
    private let categoryStore: TrackerCategoryStore
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        fetchCategories() 
    }
    
    func fetchCategories() {
        categories = categoryStore.fetchAllCategories()
    }
    
    func addCategory(name: String) {
        categoryStore.addCategory(name: name)
        fetchCategories()
    }
}
