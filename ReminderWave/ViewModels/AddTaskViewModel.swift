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
    
    // MARK: - Form State
    @Published var title = ""
    @Published var notes = ""
    @Published var isDateEnabled = false
    @Published var dueDate = Date()
    @Published var isTimeEnabled = false
    @Published var wantReminder = false
    @Published var isReminderPermitted = false
    
    // MARK: - Services
    private let taskService: TaskServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
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
            self.isReminderPermitted = success
            
            if !success {
                self.wantReminder = false
            }
        }
    }
    
    func saveTask() -> Bool {
        guard isFormValid else { return false }
        
        let task = Task(
            title: title,
            notes: notes,
            hasDueDate: isDateEnabled,
            dueDate: dueDate,
            hasTime: isTimeEnabled,
            hasReminder: wantReminder && isTimeEnabled && isReminderPermitted
        )
        
        taskService.addTask(task)
        
        if task.hasReminder {
            notificationService.scheduleNotification(for: task)
        }
        
        return true
    }
}
