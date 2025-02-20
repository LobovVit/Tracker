//
//  AddCategoryView.swift
//  Tracker
//
//  Created by Vitaly Lobov on 19.02.2025.
//

import SwiftUI

struct AddCategoryView: View {
    @ObservedObject var viewModel: TrackerCategoryViewModel
    @Binding var isPresented: Bool
    @State private var categoryName = ""
    
    var isSaveDisabled: Bool {
        categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Введите название", text: $categoryName)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Отмена")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(.black)
                            .background(Color(.black).opacity(0.3))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedName.isEmpty {
                            viewModel.addCategory(name: trimmedName)
                            isPresented = false
                        }
                    }) {
                        Text("Сохранить")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(.white)
                            .background(isSaveDisabled ? Color.gray : Color.black)
                            .cornerRadius(12)
                    }
                    .disabled(isSaveDisabled)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .navigationBarTitle("Новая категория", displayMode: .inline)
        }
    }
}
