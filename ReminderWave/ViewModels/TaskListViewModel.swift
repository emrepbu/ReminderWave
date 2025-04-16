//
//  TaskListViewModel.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

enum TaskFilterMode {
    case all
    case active
    case completed
}

class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    @Published var showingError: Bool = false
    @Published var errorMessage: String = ""
    
    private var filterMode: TaskFilterMode = .all
    
    let taskService: TaskServiceProtocol
    let notificationService: NotificationServiceProtocol
    
    init(
        taskService: TaskServiceProtocol,
        notificationService: NotificationServiceProtocol
    ) {
        self.taskService = taskService
        self.notificationService = notificationService
        loadTasks()
    }
        
    func loadTasks() {
        do {
            tasks = taskService.fetchTasks()
            applyCurrentFilter()
        } catch {
            showError(message: "Failed to load tasks")
        }
    }
    
    func deleteTask(_ task: Task) {
        do {
            if task.hasReminder {
                notificationService.cancelNotification(for: task.id)
            }
            taskService.deleteTask(task)
            loadTasks()
        } catch {
            showError(message: "Failed to delete task")
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        do {
            task.isCompleted.toggle()
            taskService.updateTask(task)
            applyCurrentFilter()
        } catch {
            showError(message: "Failed to update task")
        }
    }
    
    func changeLanguage(to languageCode: String) {
        selectedLanguage = languageCode
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
    }
    
    func showError(message: String) {
        self.errorMessage = message
        self.showingError = true
    }
    
    func setFilterMode(_ mode: TaskFilterMode) {
        self.filterMode = mode
        applyCurrentFilter()
    }
    
    private func applyCurrentFilter() {
        switch filterMode {
        case .all:
            filteredTasks = tasks
        case .active:
            filteredTasks = tasks.filter { !$0.isCompleted }
        case .completed:
            filteredTasks = tasks.filter { $0.isCompleted }
        }
    }
    
    func getUpcomingTasks(days: Int = 3) -> [Task] {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: days, to: Date())!
        
        return tasks.filter { task in
            guard task.hasDueDate && !task.isCompleted else { return false }
            return task.dueDate <= futureDate && task.dueDate >= Date()
        }.sorted { $0.dueDate < $1.dueDate }
    }
    
    func getOverdueTasks() -> [Task] {
        let now = Date()
        
        return tasks.filter { task in
            guard task.hasDueDate && !task.isCompleted else { return false }
            return task.dueDate < now
        }.sorted { $0.dueDate < $1.dueDate }
    }
    
    func setupObserver(modelContext: ModelContext) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NSManagedObjectContextObjectsDidChange"),
            object: modelContext,
            queue: .main
        ) { [weak self] _ in
            self?.loadTasks()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
