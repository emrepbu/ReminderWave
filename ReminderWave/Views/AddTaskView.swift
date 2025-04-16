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
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $viewModel.title)
                        .accessibilityLabel("Task Title")
                    
                    TextField("Notes", text: $viewModel.notes)
                        .accessibilityLabel("Task Notes")
                }
                
                Section(header: Text("Due Date")) {
                    Toggle(
                        "Set Due Date",
                        isOn: $viewModel.isDateEnabled
                    )
                    .accessibilityLabel("Enable Due Date")
                    
                    if viewModel.isDateEnabled {
                        DatePicker(
                            "Date",
                            selection: $viewModel.dueDate,
                            displayedComponents: [.date]
                        )
                        .accessibilityLabel("Select Date")
                        .datePickerStyle(GraphicalDatePickerStyle())
                        
                        Toggle("Set Time", isOn: $viewModel.isTimeEnabled)
                            .accessibilityLabel("Enable Time")
                        
                        if viewModel.isTimeEnabled {
                            DatePicker(
                                "Time",
                                selection: $viewModel.dueDate,
                                displayedComponents: [.hourAndMinute]
                            )
                            .accessibilityLabel("Select Time")
                            
                            Toggle(
                                "Set Reminder",
                                isOn: $viewModel.wantReminder
                            )
                            .accessibilityLabel("Enable Reminder")
                            .onChange(of: viewModel.wantReminder) { _, newValue in
                                if newValue {
                                    viewModel.requestNotificationPermission()
                                }
                            }
                        }
                    }
                }
                
                // Eklenen Öncelik Seçimi
                Section(header: Text("Priority")) {
                    Picker("Priority Level", selection: $viewModel.priority) {
                        Text("Low").tag(RWTaskPriority.low)
                        Text("Medium").tag(RWTaskPriority.medium)
                        Text("High").tag(RWTaskPriority.high)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accessibilityLabel("Task Priority")
                }
                
                Section {
                    Button(action: {
                        if viewModel.saveTask() {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Task")
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
                    .accessibilityLabel("Save Task Button")
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $viewModel.showPermissionAlert) {
                Alert(
                    title: Text("Notifications Disabled"),
                    message: Text("Please enable notifications in settings to receive reminders for your tasks."),
                    primaryButton: .default(Text("Settings")) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    },
                    secondaryButton: .cancel()
                )
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
