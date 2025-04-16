//
//  TaskListView.swift
//  ReminderWave
//
//  Created by argana emre on 17.04.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @StateObject var viewModel: TaskListViewModel
    @State private var showingAddTask = false
    @State private var filterMode: TaskFilterMode = .all
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    Picker("Filter", selection: $filterMode) {
                        Text("All").tag(TaskFilterMode.all)
                        Text("Active").tag(TaskFilterMode.active)
                        Text("Completed").tag(TaskFilterMode.completed)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: filterMode) { oldValue, newValue in
                        withAnimation {
                            viewModel.setFilterMode(newValue)
                        }
                    }
                    
                    if #available(iOS 17.0, *) {
                        List {
                            ForEach(viewModel.filteredTasks.sorted(by: { $0.dueDate < $1.dueDate })) { task in
                                TaskRowView(task: task) {
                                    viewModel.toggleTaskCompletion(task)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.toggleTaskCompletion(task)
                                    } label: {
                                        Label(task.isCompleted ?
                                             "Mark Incomplete" :
                                             "Mark Complete",
                                             systemImage: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                                    }
                                    .tint(task.isCompleted ? .orange : .green)
                                }
                            }
                        }
                        .scrollContentBackground(.visible)
                    } else {
                        List {
                            ForEach(viewModel.filteredTasks.sorted(by: { $0.dueDate < $1.dueDate })) { task in
                                TaskRowView(task: task) {
                                    viewModel.toggleTaskCompletion(task)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.toggleTaskCompletion(task)
                                    } label: {
                                        Label(task.isCompleted ?
                                             "Mark Incomplete" :
                                             "Mark Complete",
                                             systemImage: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                                    }
                                    .tint(task.isCompleted ? .orange : .green)
                                }
                            }
                        }
                    }
                }
                
                if viewModel.filteredTasks.isEmpty {
                    VStack {
                        Image(systemName: "checklist")
                            .font(.system(size: 70))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        if filterMode == .all {
                            Text("No Tasks")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.top)
                        } else if filterMode == .active {
                            Text("No Active Tasks")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.top)
                        } else {
                            Text("No Completed Tasks")
                                .font(.title2)s
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddTask = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                                .shadow(radius: 3)
                                .padding()
                        }
                        .transition(.scale)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.changeLanguage(to: "en")
                        }) {
                            HStack {
                                Text("English")
                                if viewModel.selectedLanguage == "en" {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button(action: {
                            viewModel.changeLanguage(to: "tr")
                        }) {
                            HStack {
                                Text("Türkçe")
                                if viewModel.selectedLanguage == "tr" {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask, onDismiss: {
                withAnimation {
                    viewModel.loadTasks()
                }
            }) {
                createAddTaskView()
            }
            .alert(isPresented: $viewModel.showingError) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
    
    @ViewBuilder
    private func createAddTaskView() -> some View {
        let taskService = SwiftDataTaskService(modelContext: modelContext)
        let notificationService = LocalNotificationService()
        let addViewModel = AddTaskViewModel(
            taskService: taskService,
            notificationService: notificationService
        )
        
        AddTaskView(viewModel: addViewModel)
    }
}

#Preview {
    let tempContainer = try! ModelContainer(for: Task.self)
    let tempContext = ModelContext(tempContainer)
    
    // Sample task for preview
    let task1 = Task(
        title: "Buy groceries",
        notes: "Milk, eggs, bread",
        hasDueDate: true,
        dueDate: Date(),
        hasTime: true,
        hasReminder: true,
        priority: .medium
    )
    
    let task2 = Task(
        title: "Finish project",
        notes: "Complete the UI design",
        isCompleted: true,
        priority: .low
    )
    
    let overdueDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
    let task3 = Task(
        title: "Complete tax report",
        notes: "Important!",
        hasDueDate: true,
        dueDate: overdueDate,
        hasTime: true,
        hasReminder: true,
        priority: .high
    )
    
    tempContext.insert(task1)
    tempContext.insert(task2)
    tempContext.insert(task3)
    
    // Create view model with sample data
    let viewModel = TaskListViewModel(
        taskService: SwiftDataTaskService(modelContext: tempContext),
        notificationService: LocalNotificationService()
    )
    
    return TaskListView(viewModel: viewModel)
        .modelContainer(for: Task.self, inMemory: true)
}
