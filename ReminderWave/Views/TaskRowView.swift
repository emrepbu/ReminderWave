//
//  TaskRowView.swift
//  ReminderWave
//
//  Created by argana emre on 16.04.2025.
//

import SwiftUI

struct TaskRowView: View {
    var task: Task
    var onToggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 8.0
            ) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .strikethrough(task.isCompleted)
                
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                if task.hasDueDate {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        
                        Text(task.dueDate, style: .date)
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        if task.hasTime {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            
                            Text(task.dueDate, style: .time)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        if task.hasReminder {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                }
            }
            
            Spacer()
            
            Circle()
                .strokeBorder(task.isCompleted ? .green : .gray, lineWidth: 2.0)
                .background(
                    Circle()
                        .fill(task.isCompleted ? Color.green : Color.clear)
                )
                .frame(width: 24, height: 24)
                .overlay {
                    task.isCompleted ?
                    Image(systemName: "checkmark")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    : nil
                }
                .onTapGesture {
                    withAnimation {
                        onToggleCompletion()
                    }
                }
        }
        .padding(.vertical, 8.0)
    }
}

#Preview("Incomplete Task") {
    let task = Task(
        title: "Buy groceries",
        notes: "Milk, eggs, bread",
        isCompleted: false,
        hasDueDate: true,
        dueDate: Date(),
        hasTime: true,
        hasReminder: true
    )
    
    return TaskRowView(task: task) {}
        .padding()
}

#Preview("Completed Task") {
    let task = Task(
        title: "Finish project",
        notes: "Complete the UI design",
        isCompleted: true,
        hasDueDate: true,
        dueDate: Date(),
        hasTime: false,
        hasReminder: false
    )
    
    return TaskRowView(task: task) {}
        .padding()
}
