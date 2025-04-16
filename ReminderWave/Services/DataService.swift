//
//  DataService.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import Foundation
import SwiftData

protocol TaskServiceProtocol {
    func fetchTasks() -> [Task]
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}

class SwiftDataTaskService: TaskServiceProtocol {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
    }

    func fetchTasks() -> [Task] {
        do {
            let descriptor = FetchDescriptor<Task>(
                sortBy: [SortDescriptor(\.dueDate)]
            )
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func addTask(_ task: Task) {
        modelContext.insert(task)
        saveContext()
    }
    
    func updateTask(_ task: Task) {
        saveContext()
    }
    
    func deleteTask(_ task: Task) {
        modelContext.delete(task)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
