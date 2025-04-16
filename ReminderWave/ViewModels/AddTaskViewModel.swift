//
//  AddTaskViewModel.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftUI
import Combine

class AddTaskViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var notes = ""
    @Published var isDateEnabled = false
    @Published var dueDate = Date()
    @Published var isTimeEnabled = false
    @Published var wantReminder = false
    @Published var isReminderPermitted = false
    @Published var priority: RWTaskPriority = .medium
    @Published var showPermissionAlert = false
    
    private let taskService: TaskServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    var onTaskSaved: (() -> Void)?
    
    init(
        taskService: TaskServiceProtocol,
        notificationService: NotificationServiceProtocol
    ) {
        self.taskService = taskService
        self.notificationService = notificationService
    }
    
    var isFormValid: Bool {
        !title.isEmpty
    }
    
    func requestNotificationPermission() {
        notificationService.requestAuthorization { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isReminderPermitted = success
                
                if !success {
                    self.wantReminder = false
                    self.showPermissionAlert = true
                }
            }
        }
    }
    
    func saveTask() -> Bool {
        guard isFormValid else { return false }
        
        var taskSaved = true
        
        do {
            let task = Task(
                title: title,
                notes: notes,
                isCompleted: false,
                hasDueDate: isDateEnabled,
                dueDate: dueDate,
                hasTime: isTimeEnabled,
                hasReminder: wantReminder && isTimeEnabled && isReminderPermitted,
                priority: priority
            )
            
            taskService.addTask(task)
            
            if task.hasReminder {
                notificationService.scheduleNotification(for: task)
            }

            onTaskSaved?()
            
        } catch {
            taskSaved = false
            print("Error saving task: \(error)")
        }
        
        return taskSaved
    }
    
    func resetForm() {
        title = ""
        notes = ""
        isDateEnabled = false
        dueDate = Date()
        isTimeEnabled = false
        wantReminder = false
        priority = .medium
    }
}
