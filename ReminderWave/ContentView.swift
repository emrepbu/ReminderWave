//
//  ContentView.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: TaskListViewModel
    
    init() {
        let notificationService = LocalNotificationService()
        _viewModel = StateObject(wrappedValue: TaskListViewModel(
            taskService: SwiftDataTaskService(modelContext: modelContext),
            notificationService: notificationService
        ))
    }
    
    var body: some View {
        TaskListView(viewModel: viewModel)
            .onAppear {
                if let taskService = viewModel.taskService as? SwiftDataTaskService {
                    taskService.updateModelContext(modelContext)
                    viewModel.loadTasks()
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
