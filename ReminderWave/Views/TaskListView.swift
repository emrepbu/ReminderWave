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
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.tasks.sorted(by: { $0.dueDate < $1.dueDate })) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleTaskCompletion(task)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTask(task)
                            } label: {
                                Label(String(localized: "Delete"), systemImage: "trash")
                            }

                            Button {
                                viewModel.toggleTaskCompletion(task)
                            } label: {
                                Label(task.isCompleted ?
                                     String(localized: "Mark Incomplete") :
                                     String(localized: "Mark Complete"),
                                     systemImage: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                            }
                            .tint(task.isCompleted ? .orange : .green)
                        }
                    }
                }
                
                if viewModel.tasks.isEmpty {
                    VStack {
                        Image(systemName: "checklist")
                            .font(.system(size: 70))
                            .foregroundColor(.gray.opacity(0.7))
                        Text(String(localized: "No Tasks"))
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.top)
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
            .navigationTitle(String(localized: "Tasks"))
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
    let task1 = Task(title: "Buy groceries", notes: "Milk, eggs, bread", hasDueDate: true, dueDate: Date(), hasTime: true, hasReminder: true)
    let task2 = Task(title: "Finish project", notes: "Complete the UI design", isCompleted: true)
    
    tempContext.insert(task1)
    tempContext.insert(task2)
    
    // Create view model with sample data
    let viewModel = TaskListViewModel(
        taskService: SwiftDataTaskService(modelContext: tempContext),
        notificationService: LocalNotificationService()
    )
    
    return TaskListView(viewModel: viewModel)
        .modelContainer(for: Task.self, inMemory: true)
}
