//
//  TrackerCategoryView.swift
//  Tracker
//
//  Created by Vitaly Lobov on 17.02.2025.
//

import SwiftUI

struct TrackerCategoryView: View {
    @ObservedObject var viewModel: TrackerCategoryViewModel
    @Binding var trackerCategory: String?
    var onCategorySelected: ((TrackerCategoryCoreData) -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddingCategory = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        trackerCategory = category.name
                        onCategorySelected?(category)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(category.name ?? "Unknown")
                                .font(.system(size: 18, weight: .medium))
                                .frame(height: 50)
                            Spacer()
                            if trackerCategory == category.name {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                }
                
                Spacer()
                
                Button(action: {
                    isAddingCategory = true
                }) {
                    Text("Добавить категорию")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
            }
            .navigationBarTitle("Категории", displayMode: .inline)
            .sheet(isPresented: $isAddingCategory) {
                AddCategoryView(viewModel: viewModel, isPresented: $isAddingCategory)
            }
        }
    }
    
}
