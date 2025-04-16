//
//  TaskListViewModel.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftUI
import Combine

class TaskListViewModel: ObservableObject {
    
    // MARK: - Published properties
    @Published var tasks: [Task] = []
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    
    // MARK: - Services
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
    
    // MARK: - Functions
    
    func loadTasks() {
        tasks = taskService.fetchTasks()
    }
    
    func deleteTask(_ task: Task) {
        if task.hasReminder {
            notificationService.cancelNotification(for: task.id)
        }
        taskService.deleteTask(task)
        loadTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        taskService.updateTask(task)
    }
    
    func changeLanguage(to languageCode: String) {
        selectedLanguage = languageCode
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
    }
}
