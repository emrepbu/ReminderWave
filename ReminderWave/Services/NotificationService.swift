//
//  NotificationService.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleNotification(for task: Task)
    func cancelNotification(for taskId: UUID)
}

class LocalNotificationService: NotificationServiceProtocol {
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func scheduleNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Task Reminder")
        content.body = task.title
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([
            .year,
            .month,
            .day,
            .hour,
            .minute
        ], from: task.dueDate)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for taskId: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [taskId.uuidString]
            )
    }
}
