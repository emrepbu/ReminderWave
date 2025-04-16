//
//  AddTaskView.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    
    @ObservedObject var viewModel: AddTaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(String(localized: "Task Details"))) {
                    TextField(String(localized: "Title"), text: $viewModel.title)
                    TextField(String(localized: "Notes"), text: $viewModel.notes)
                }
                
                Section(header: Text(String(localized: "Due Date"))) {
                    Toggle(
                        String(localized: "Set Due Date"),
                        isOn: $viewModel.isDateEnabled
                    )
                    
                    if viewModel.isDateEnabled {
                        DatePicker(
                            String(localized: "Date"),
                            selection: $viewModel.dueDate,
                            displayedComponents: [.date]
                        )
                        
                        Toggle(LocalizedStringKey("Set Time"), isOn: $viewModel.isTimeEnabled)
                        
                        if viewModel.isTimeEnabled {
                            DatePicker(
                                String(localized: "Time"),
                                selection: $viewModel.dueDate,
                                displayedComponents: [.hourAndMinute]
                            )
                            
                            Toggle(
                                String(localized: "Set Reminder"),
                                isOn: $viewModel.wantReminder
                            )
                            .onChange(of: viewModel.wantReminder) { _, newValue in
                                if newValue {
                                    viewModel.requestNotificationPermission()
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        if viewModel.saveTask() {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(String(localized: "Save Task"))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(!viewModel.isFormValid ? Color.gray : Color.blue)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle(String(localized: "New Task"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let viewModel = AddTaskViewModel(
        taskService: SwiftDataTaskService(modelContext: ModelContext(try! ModelContainer(for: Task.self))),
        notificationService: LocalNotificationService()
    )
    
    return AddTaskView(viewModel: viewModel)
        .modelContainer(for: Task.self, inMemory: true)
}
