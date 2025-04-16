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
    var hasTime: Bool
    var hasReminder: Bool
    
    init(
         id: UUID = UUID(),
         title: String,
         notes: String = "",
         isCompleted: Bool = false,
         hasDueDate: Bool = false,
         dueDate: Date = Date(),
         hasTime: Bool = false,
         hasReminder: Bool = false
     ) {
         self.id = id
         self.title = title
         self.notes = notes
         self.isCompleted = isCompleted
         self.hasDueDate = hasDueDate
         self.dueDate = dueDate
         self.hasTime = hasTime
         self.hasReminder = hasReminder
     }
}
