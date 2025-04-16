//
//  Task.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftData

@Model
final class Task {
    var id: UUID
    var title: String
    var notes: String
    var isCompleted: Bool
    var hasDueDate: Bool
    var dueDate: Date
    var hasReminder: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        notes: String,
        isCompleted: Bool,
        hasDueDate: Bool,
        dueDate: Date,
        hasReminder: Bool
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.hasDueDate = hasDueDate
        self.dueDate = dueDate
        self.hasReminder = hasReminder
    }
}
