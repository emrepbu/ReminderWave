//
//  Task.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftData
import SwiftUI

enum RWTaskPriority: Int, Codable {
    case low = 0
    case medium = 1
    case high = 2
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
    
    var name: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

@Model
final class Task {
    var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var hasDueDate: Bool
    var dueDate: Date
    var hasTime: Bool
    var hasReminder: Bool
    var priority: RWTaskPriority
    var createdAt: Date
    var lastModified: Date
    
    init(
         id: UUID = UUID(),
         title: String,
         notes: String = "",
         isCompleted: Bool = false,
         hasDueDate: Bool = false,
         dueDate: Date = Date(),
         hasTime: Bool = false,
         hasReminder: Bool = false,
         priority: RWTaskPriority = .medium,
         createdAt: Date = Date(),
         lastModified: Date = Date()
     ) {
         self.id = id
         self.title = title
         self.notes = notes
         self.isCompleted = isCompleted
         self.hasDueDate = hasDueDate
         self.dueDate = dueDate
         self.hasTime = hasTime
         self.hasReminder = hasReminder
         self.priority = priority
         self.createdAt = createdAt
         self.lastModified = lastModified
     }
    
    var isOverdue: Bool {
        guard hasDueDate && !isCompleted else { return false }
        return dueDate < Date()
    }
    
    var isDueToday: Bool {
        guard hasDueDate && !isCompleted else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }
    
    var isUpcoming: Bool {
        guard hasDueDate && !isCompleted else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let taskDate = calendar.startOfDay(for: dueDate)
        
        if let days = calendar.dateComponents([.day], from: today, to: taskDate).day, days >= 0 && days <= 3 {
            return true
        }
        return false
    }
}
